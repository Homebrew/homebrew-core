class Libcpucycles < Formula
  desc "Microlibrary for counting CPU cycles"
  homepage "https://cpucycles.cr.yp.to/"
  url "https://cpucycles.cr.yp.to/libcpucycles-20250925.tar.gz"
  sha256 "62313d42ad5a3cbd8d41a9fb7088edc328ef499d426e1f191612331d0fcbe301"
  license any_of: [:public_domain, "CC0-1.0", "0BSD", "MIT-0", "MIT"]

  livecheck do
    url "https://cpucycles.cr.yp.to/libcpucycles-latest-version.txt"
    regex(/^v?(\d{8})$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33d1e7a7944ff4b2ce31683614599fda98fcf65b7a9b9c7cf2af89674643c143"
    sha256 cellar: :any,                 arm64_sequoia: "cb8520f064eab6bfce9f427e69fdbd2e24dd4caabef67cc4d8bef5626236ff74"
    sha256 cellar: :any,                 arm64_sonoma:  "675cc5ceea5a0aeeea70a77059b1cb653506a58720a5d79c71ebd0ea73d42d8d"
    sha256 cellar: :any,                 sonoma:        "097b6a67c47e89a515809b614c90f9207d1ad03639faef285e3688dde523dfb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c93749431c936fa122df328a19ed7adb2f2a4d0eae8a3d503dd319e503ff158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66816df032dd11eab604c8477513510d038692bf979d2338cbeb9b1c3038edaa"
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
