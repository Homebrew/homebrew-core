class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.9.tar.xz"
  sha256 "72de9d278f74d95d320ec7b0d745296f582264799eab908260dbea0ce8e08f83"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9cd2947492b3f29a500e1a45bd3721de23944ac43f3deb7fdb8ae5a9931a9acf"
    sha256 arm64_monterey: "0cd31c02ff18e5ce5561bebaea0096b04a78f7b761f2994f022c65bbbb4379dd"
    sha256 arm64_big_sur:  "9238c3ea5a96d566c6b531637cae7c07d2aca46f7bbaba67ffcd8421bbd5fe6f"
    sha256 ventura:        "a8cdbbffad5eca7bb7c5fa3352df4cb4fe044ae9215b0ddc4a3ba194309cdefd"
    sha256 monterey:       "90ec4cbb2593c65b1ed2ae3908f610e864581a634d20e78874354e408f7f8c63"
    sha256 big_sur:        "61f4aa90ea524c8d5891213400075ebd496462f48aa1caf1b8e7ec3279504f6f"
    sha256 catalina:       "c3ec401e08a4ed98d9d36b9536964db97f9073dc73b77148ff12ac2239e3a6da"
    sha256 x86_64_linux:   "fc7e1e0901a6cfa77aef555b843df784aeaff81ebdd27a5cd866b3818389f1ec"
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
