class Bstring < Formula
  desc "Fork of Paul Hsieh's Better String Library"
  homepage "https://mike.steinert.ca/bstring/"
  url "https://github.com/msteinert/bstring/releases/download/v1.1.0/bstring-1.1.0.tar.xz"
  sha256 "1b513965a658494193ab9431c229ea675a7b1c7c85de9d68b8cc089abfb82240"
  license "BSD-3-Clause"
  head "https://github.com/msteinert/bstring.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66f545fd557342e3560304aa78e39175200a6f273955bab4fafe33388e1708aa"
    sha256 cellar: :any,                 arm64_sequoia: "44c469620eaedcf00a73624f1dfcd9b2e9938cb996154d968fa10839633e71ff"
    sha256 cellar: :any,                 arm64_sonoma:  "0c44ce068f5f426899aaf2015c23a35550c28188e18e1d13266547491cce4e8b"
    sha256 cellar: :any,                 sonoma:        "2f842371020537e4110b9fe388ed73ad7488435ecb04d75aa390c75f0da664d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c13cb49f5a8255a1c8adf436297f6cbd5e6e49890f45d772ad079f9a1c97e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db207735a893a428a7e470852c19e223eb24a208b53b14a13c0e4a4061c598a"
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
