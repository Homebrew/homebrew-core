class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "47ec02be6c0a6323044600a9221b049f63e1953faf816903e7383d4dc4234487"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "21fd113696ea75a62b9a2639f08af0fd4283503c9d479dd7168b9c744d160ea1"
    sha256 cellar: :any,                 arm64_sequoia:  "dc994f773c7bb0e13fcddb6ceda95f38d0aa0cac86ee883da34e90bf38d7ba39"
    sha256 cellar: :any,                 arm64_sonoma:   "172505ff5448c82fbdb5572865635db579c938aa58af45385606be5b949ff87e"
    sha256 cellar: :any,                 arm64_ventura:  "75bd64679f3a4c3983c71dddde8346ed9e792f999e28fe8d5f3bf0b08b905e43"
    sha256 cellar: :any,                 arm64_monterey: "5379a4c948c514c3800c321df890d709ee4e6e0676c4efd786231507fc9ffeb2"
    sha256 cellar: :any,                 arm64_big_sur:  "ce086dec03a0d2fdb36c033db18393be5e789a0f8586594f624d39ddd263d9f7"
    sha256 cellar: :any,                 sonoma:         "40fbad3037a97c742a4e7c51db7903767e5b6c439f2344230d9091367e8ff63e"
    sha256 cellar: :any,                 ventura:        "c76aaaf78c156d1ff0af19e0219c159a2da0e3134c3fb936057b566f6e10e9d5"
    sha256 cellar: :any,                 monterey:       "fdcbf11ea62d2dcbb6aaa56dd9f7f1b162c592de5a7301c09976ebb2113e217e"
    sha256 cellar: :any,                 big_sur:        "2f1bee0c91bf53b0289d067a93dfe45896f8f979914486c08e264571b82e2d91"
    sha256                               arm64_linux:    "64efbd30e15ac3ce66bd2f493973aaa3a56229859de2fe3227f824c36175acc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a77bbbc2800f350812338cb58d7a588f33fd2a7bac3eb0e2be6c7acfb3687f2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install "examples/example.c"
  end

  test do
    fixture = test_fixtures("test.png")
    cp pkgshare/"example.c", testpath/"example.c"
    system ENV.cc, "example.c", "-L#{lib}", "-I#{include}", "-lspng", "-o", "example"

    output = shell_output("./example #{fixture}")
    assert_match "width: 8\nheight: 8\nbit depth: 1\ncolor type: 3 - indexed color\n" \
                 "compression method: 0\nfilter method: 0\ninterlace method: 0", output
  end
end
