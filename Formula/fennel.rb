class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.0.0.tar.gz"
  sha256 "6f619832751af9c37835737cde5cf4475ff90e073ecef4671f9e4f8be2c121a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f714051d4f36526946b7ec3b851aa9611667dc842eb5ee39176782063711687"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b303b75ea84c7ad5dc2ae4151ec2ef719c7aaf61d92e196f1ee983134becfeba"
    sha256 cellar: :any_skip_relocation, monterey:       "351448ec8875b2f03dacfe64d1609d9f95918c8a872024a310440cdd39f2852b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e6b9ad343605bd0415f1e7702cbcb8a593124dfe19f369488ab6b271c263aa8"
    sha256 cellar: :any_skip_relocation, catalina:       "4dce4d33dae0cf5840aa26e9a42c3a9f06dec53551494e7497e230f7c885e10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28acc6e293fd6c3e4ce5518c59efc80a31be142585247ec59e8338316376f4cb"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
