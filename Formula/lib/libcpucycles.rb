class Libcpucycles < Formula
  desc "Microlibrary for counting CPU cycles"
  homepage "https://cpucycles.cr.yp.to/"
  url "https://cpucycles.cr.yp.to/libcpucycles-20260105.tar.gz"
  sha256 "e87dcaaa28e905b574ccf3d49e23e05c73edb3f99136dcd566bca16829ab6694"
  license any_of: [:public_domain, "CC0-1.0", "0BSD", "MIT-0", "MIT"]

  livecheck do
    url "https://cpucycles.cr.yp.to/libcpucycles-latest-version.txt"
    regex(/^v?(\d{8})$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d0d624a923f07935e6e91ea524def9d852f5a6916bf501b8661e4c7983fc2af"
    sha256 cellar: :any,                 arm64_sequoia: "44eda163d6b173499275564c2a96ca7d51e0156875c2b75674b56839e17ca37c"
    sha256 cellar: :any,                 arm64_sonoma:  "1596cb50ee60f75911e1b4f05949645f055d7a8775c57ede61f478171be0068b"
    sha256 cellar: :any,                 sonoma:        "05e0ac733b7b0ba78b14dc929bf41901aceedfc293a9b1aa55f767814d45e79f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79fa7b230fc71e0576f56eaed3ba4656e76844a52e5272efd4dfa55f04605c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6bac3d0373927187fc0aa235374d1c0e1bc9b4df30bff91f80cb3242996504"
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
