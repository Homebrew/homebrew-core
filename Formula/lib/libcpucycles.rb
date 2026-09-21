class Libcpucycles < Formula
  desc "Microlibrary for counting CPU cycles"
  homepage "https://cpucycles.cr.yp.to/"
  url "https://cpucycles.cr.yp.to/libcpucycles-20260901.tar.gz"
  sha256 "c914c7275952ed00bb188e1170409c83b61abfd0b828cdb2b5a87275be43344e"
  license any_of: [:public_domain, "CC0-1.0", "0BSD", "MIT-0", "MIT"]

  livecheck do
    url "https://cpucycles.cr.yp.to/libcpucycles-latest-version.txt"
    regex(/^v?(\d{8})$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "498ea34a839ccb2235e89cb93b923f20521d7d6074add859f38c5b94f555a598"
    sha256 cellar: :any, arm64_tahoe:       "9862a1f806317cdce8e39a432a16748b85fd659c0b8cf9b93e263c4affa76c8c"
    sha256 cellar: :any, arm64_sequoia:     "5e8fb37857f44609865073a133a7e9f415841c3af6dc65b76cfccaa42de8dceb"
    sha256 cellar: :any, arm64_sonoma:      "475bc9a74ea35ec1975673fd42d9dd0e30021a9785ad4407112550098315254e"
    sha256 cellar: :any, arm64_linux:       "dc260229f941163e2b2d45eed68dee2ed52454a3f116fe236f343cceedd9f9d3"
    sha256 cellar: :any, x86_64_linux:      "8d0e3a42584d98f6b54d5104bff85e966183d00706bcffce1c9b5ac17c520052"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <cpucycles.h>

      int main(void) {
        assert(cpucycles() < cpucycles());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lcpucycles"
    system "./test"

    assert_match(/^cpucycles version #{version}$/, shell_output(bin/"cpucycles-info"))
  end
end
