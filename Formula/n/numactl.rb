class Numactl < Formula
  desc "NUMA support for Linux"
  homepage "https://github.com/numactl/numactl"
  url "https://github.com/numactl/numactl/releases/download/v2.0.19/numactl-2.0.19.tar.gz"
  sha256 "f2672a0381cb59196e9c246bf8bcc43d5568bc457700a697f1a1df762b9af884"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", :public_domain, :cannot_represent]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cbabb9e7d3bccc03ad04aa04e52a009f37fc8d2f725d37fa369f9149de61fefa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43bce9542369d74930001dfdc0e77f532ec0dd93f41f1ade35f0205c800270cc"
  end

  depends_on :linux

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <numa.h>
      int main() {
        if (numa_available() >= 0) {
          struct bitmask *mask = numa_allocate_nodemask();
          numa_free_nodemask(mask);
        }
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lnuma", "-o", "test"
    system "./test"
  end
end
