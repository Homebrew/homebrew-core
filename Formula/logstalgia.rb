class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.3/logstalgia-1.1.3.tar.gz"
  sha256 "82e6a33c3c305c1f1d32d7e115ba0b307bb191ed2a70368a3cd9138ced0a98d9"
  license "GPL-3.0"

  bottle do
    sha256 arm64_monterey: "613467e1f9bd7b051fbb6c31370f8e7a39c0889037d545a303d88ecac5a59fa3"
    sha256 arm64_big_sur:  "9c8e8ae7c6d2fecce41f7ee986b0070c00abcc26a9ede7c0a89710e3921e73e9"
    sha256 monterey:       "ae779187ec2efaea84f01a3602ce99876d75e6fefcfa64825a6a43f3cc4bae07"
    sha256 big_sur:        "8317c3e8cc8d1ae6d10457ccb7b2fb4d9add7b7b8b208dc70fccd49c556213d8"
    sha256 catalina:       "e292916be0cc939d985c4f42930d5217cf06d1e57fa2a3e376d55a44c4b21fd9"
    sha256 mojave:         "ecc61da046585777d74c682a14f6e3963570603188d2d447d3fbc4c5f87895dd"
    sha256 high_sierra:    "c0411062c997c5ca8aaf27726d2205601438a50ccbecc9a166c26c30bd3c08aa"
    sha256 x86_64_linux:   "c21a106cfe8e3cb7538c31f7bbfebb571765ae0265f401070dfb8a69609c2877"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", *std_configure_args,
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
