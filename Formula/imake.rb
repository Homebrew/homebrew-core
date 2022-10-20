class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.8.tar.bz2"
  sha256 "b8d2e416b3f29cd6482bcffaaf19286d32917a164d07102a0e531ccd41a2a702"
  license "MIT"
  revision 6

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "16a1925ce2b28d8d3aefc1fd554cfa74fff7c05a5b81847f7c3340717e5c5149"
    sha256 arm64_big_sur:  "981cf5a9966c199d0955266f7d7f8ca8d22742c3a952ee4d30547437caaf6d3c"
    sha256 monterey:       "f5be1c74dc23cb33de8eac020f9dc293bca0a7ed36308a46676a60a4c438428b"
    sha256 big_sur:        "0c0f73e6dc9edb4792e789e6235fe20e9f5a21a32a5d66a8e59e7c2f953b77ed"
    sha256 catalina:       "cd6a5f473087960077709005c51b86ef377ea3d4a5d32e9f1d17b37d65629181"
    sha256 x86_64_linux:   "44e14e698e25dabfa8e7ee4d1ba913fa332cffed12b986951dddf680f9afe029"
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
