class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.8.tar.bz2"
  sha256 "b8d2e416b3f29cd6482bcffaaf19286d32917a164d07102a0e531ccd41a2a702"
  license "MIT"
  revision 5

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cac05a33d22a4ff366800773add7510ff1978350e715740b88333df4e3fc2010"
    sha256 arm64_big_sur:  "12bf7ce30f94dd7be1349a6c975eb01d5e999febbe0b0004bfd2387797b9d547"
    sha256 monterey:       "b3ec19fa38cedb060936d2f0a25293ed928c663070a840b710e39c9aae1981a8"
    sha256 big_sur:        "4fa7efb9da19d368dbbcbe6290c6314ce0d95026f96cdc41d089e43b2573b81a"
    sha256 catalina:       "a28b2a436f43b61cd3862b909797b1482263be6b7e2d51a3dbf67da3c529b209"
    sha256 x86_64_linux:   "c9f6b1a2d6aaa005ec3268c49e22fd71bce9469a2c05853cb4d1fdf9b4c31fc3"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "tradcpp"

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.6.tar.bz2"
    sha256 "4dcf5a9dbe3c6ecb9d2dd05e629b3d373eae9ba12d13942df87107fdc1b3934d"
  end

  def install
    ENV.deparallelize

    # imake runtime is broken when used with clang's cpp
    cpp_program = Formula["tradcpp"].opt_bin/"tradcpp"
    (buildpath/"imakemdep.h").append_lines [
      "#define DEFAULT_CPP \"#{cpp_program}\"",
      "#undef USE_CC_E",
    ]
    inreplace "imake.man", /__cpp__/, cpp_program

    # also use gcc's cpp during buildtime to pass ./configure checks
    ENV["RAWCPP"] = cpp_program

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    resource("xorg-cf-files").stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{HOMEBREW_PREFIX}/include"
      system "./configure", "--with-config-dir=#{lib}/X11/config",
                            "--prefix=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    # Use pipe_output because the return code is unimportant here.
    output = pipe_output("#{bin}/imake -v -s/dev/null -f/dev/null -T/dev/null 2>&1")
    assert_match "#{Formula["tradcpp"].opt_bin}/tradcpp", output
  end
end
