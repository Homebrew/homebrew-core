class Bstring < Formula
  desc "Fork of Paul Hsieh's Better String Library"
  homepage "https://mike.steinert.ca/bstring/"
  url "https://github.com/msteinert/bstring/releases/download/v1.0.2/bstring-1.0.2.tar.xz"
  sha256 "9d2d207385edeb39935c53f55da57501936b67939998f3e5c5ae91cb8063fbd0"
  license "BSD-3-Clause"
  head "https://github.com/msteinert/bstring.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1e90be7e803669e7991a57a28a5b794e85b99395785dbf0295bffb6e5d767cd"
    sha256 cellar: :any,                 arm64_sequoia: "5afe2c7f9f916ae7206ab606c7025d7397098014aa073f2a57d87fc9ab51a5c6"
    sha256 cellar: :any,                 arm64_sonoma:  "78f3d3247818a2696b0891ca9d77aa917e31c5787ab6c00b85d5f89092d16a23"
    sha256 cellar: :any,                 arm64_ventura: "dd284a39954e4ae73c5f40c2a4efc4517b766f42f5125a4ead9df89c1e497af6"
    sha256 cellar: :any,                 sonoma:        "5de48227a28ec7e83e10da7af7bec5456fe63cb285203781c961607ea2e2b6e9"
    sha256 cellar: :any,                 ventura:       "7ec5942fdf326cb735c0f67198227fa3fb35e757d9f0b4e0da7a6e2432f3ef36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65262afabaab0dc134f62a51ea73a1aaeb7d065f20de7337f4b06d0588aa65de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bbcd5e8694faaeffece44cba6782b6632610146d72f9a13ac4ee9a6b2e0f5f3"
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
