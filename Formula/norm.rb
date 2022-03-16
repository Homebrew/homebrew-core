class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://github.com/USNavalResearchLaboratory/norm/releases/download/v1.5.9/src-norm-1.5.9.tgz"
  sha256 "ef6d7bbb7b278584e057acefe3bc764d30122e83fa41d41d8211e39f25b6e3fa"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a8a59ed661565f3cf10b7bc5eaedb45d90cc949031d5d36a9b098985e8da71cc"
    sha256 cellar: :any, arm64_big_sur:  "658241c3120a66b68191f64e4009617d9ee0e43c5cd264e0db59f9dd2aeca966"
    sha256 cellar: :any, monterey:       "024bbaf98d384ee89e3ff5db7e56dc706dcc6f445ea3ebd976bd32c21fe24bcf"
    sha256 cellar: :any, big_sur:        "0d223adbb36c557616fbb8e026e93a36603ff5478ea3912978190389e409b04a"
    sha256 cellar: :any, catalina:       "b01566af6d67555366f350e72a9717479c1510af885a89b60827356aeba7d2af"
    sha256 cellar: :any, mojave:         "bc9f51046dc479949b480bb9a27143679bccb5f4bab0928c5968d280f9489d86"
    sha256 cellar: :any, high_sierra:    "c46470e7594148cbee61f851b57373374abdc6a94e91c722efabd3c90f36ec06"
  end

  depends_on "python@3.10" => :build

  # Fix warning: 'visibility' attribute ignored [-Wignored-attributes]
  # Remove in the next release
  #
  # Ref https://github.com/USNavalResearchLaboratory/norm/pull/27
  patch do
    url "https://github.com/USNavalResearchLaboratory/norm/commit/476b8bb7eba5a9ad02e094de4dce05a06584f5a0.patch?full_index=1"
    sha256 "08f7cc7002dc1afe6834ec60d4fea5c591f88902d1e76c8c32854a732072ea56"
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "install"

    include.install "include/normApi.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <normApi.h>

      int main()
      {
        NormInstanceHandle i;
        i = NormCreateInstance(false);
        assert(i != NORM_INSTANCE_INVALID);
        NormDestroyInstance(i);
        return 0;
      }
    EOS
    system ENV.cxx, "test.c", "-L#{lib}", "-lnorm", "-o", "test"
    system "./test"
  end
end
