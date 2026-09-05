class Bstring < Formula
  desc "Fork of Paul Hsieh's Better String Library"
  homepage "https://mike.steinert.ca/bstring/"
  url "https://github.com/msteinert/bstring/releases/download/v1.1.1/bstring-1.1.1.tar.xz"
  sha256 "caaa9770c763dfc31a34e86d4afe50a9d3b3e6c43f9b410fa4f3130192ea47f1"
  license "BSD-3-Clause"
  head "https://github.com/msteinert/bstring.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f46d07f7afa97ec3ed27924da2b06af56046c6aa6229dc8617efae46aaf7d5c8"
    sha256 cellar: :any, arm64_sequoia: "e3f3e05e03d8e3e5f6ea5cb49565295c9a77f1469f9c5cdcf7aac78cf0a679e8"
    sha256 cellar: :any, arm64_sonoma:  "cb3042db71a6e28cfbaab9dca1e3d115541cb453845734ad15a27eca60490a80"
    sha256 cellar: :any, arm64_linux:   "0723348b119a474ce5777dfe9c980fc87b999795abda090e377469ceafc1459f"
    sha256 cellar: :any, x86_64_linux:  "a32ee843a1fe747475d7f2731f3caafbd1738956b47fd15d95b00d73926af9e8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "check" => :test

  def install
    args = %w[-Denable-docs=false -Denable-tests=false]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/bstest.c", "."

    check = Formula["check"]
    ENV.append_to_cflags "-I#{include} -I#{check.opt_include}"
    ENV.append "LDFLAGS", "-L#{lib} -L#{check.opt_lib}"
    ENV.append "LDLIBS", "-lbstring -lcheck"

    system "make", "bstest"
    system "./bstest"
  end
end
