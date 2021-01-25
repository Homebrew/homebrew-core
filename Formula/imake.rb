class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.8.tar.bz2"
  sha256 "b8d2e416b3f29cd6482bcffaaf19286d32917a164d07102a0e531ccd41a2a702"
  license "MIT"
  revision 3

  bottle do
    sha256 "c382f4319ca3b0138c5d20bfeea095d76ca9c972e166550b58f259f03a5d267c" => :big_sur
    sha256 "7eafaa82ad84b47d8f4bd76bdca5ccfa065f622ea31b1d2c05fb316af8f60015" => :arm64_big_sur
    sha256 "fadd526555076cbe59ef74e14456c732a084230e3bf23a78df259f222b11b4fc" => :catalina
    sha256 "211e42f25de025770eae0cf3b5ca2c5f03821a809009e0111115f808cd498ab1" => :mojave
    sha256 "582ea346c5d5caaa38795e2221172358b584e22cfe25ec48cacf78467272b257" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "gcc"

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.6.tar.bz2"
    sha256 "4dcf5a9dbe3c6ecb9d2dd05e629b3d373eae9ba12d13942df87107fdc1b3934d"
  end

  def install
    ENV.deparallelize

    # imake runtime is broken when used with clang's cpp
    gcc_major_ver = Formula["gcc"].any_installed_version.major
    cpp_program = Formula["gcc"].opt_bin/"cpp-#{gcc_major_ver}"
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
    gcc_major_ver = Formula["gcc"].any_installed_version.major
    assert_match "#{Formula["gcc"].opt_bin}/cpp-#{gcc_major_ver}", output
  end
end
