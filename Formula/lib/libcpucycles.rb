class Libcpucycles < Formula
  desc "Microlibrary for counting CPU cycles"
  homepage "https://cpucycles.cr.yp.to/"
  url "https://cpucycles.cr.yp.to/libcpucycles-20260625.tar.gz"
  sha256 "74a815bfb5ab645e5d07617125824c946ce5039db139e5233467d1ff33f69afa"
  license any_of: [:public_domain, "CC0-1.0", "0BSD", "MIT-0", "MIT"]

  livecheck do
    url "https://cpucycles.cr.yp.to/libcpucycles-latest-version.txt"
    regex(/^v?(\d{8})$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "89f1fd69d972090bdf0c6e9e7095d87971ad9402aaf58c2fa841b6d5589214df"
    sha256 cellar: :any, arm64_sequoia: "e0236efc50999493ab9170dfc6cee0d3e162cbaf3d8258d880fba15b75b215c7"
    sha256 cellar: :any, arm64_sonoma:  "f9b15ca1dd81796fb73ac20d8e2f7adf4d26a24014ef2c9a066851a4196deadd"
    sha256 cellar: :any, sonoma:        "b0dfb04632627992e32894bb9a47c8362e03e7e1add1037b192c5be93618219c"
    sha256 cellar: :any, arm64_linux:   "8dd135a6eb7c4b965578e43ace39173540e5f490f6ea69943c6bbb1430dcfb3e"
    sha256 cellar: :any, x86_64_linux:  "3ec314ba83606d0e13f5b904eee184f7c4d1551f80b68e08700ed13aae094179"
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
