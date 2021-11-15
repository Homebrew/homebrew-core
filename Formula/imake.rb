class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.8.tar.bz2"
  sha256 "b8d2e416b3f29cd6482bcffaaf19286d32917a164d07102a0e531ccd41a2a702"
  license "MIT"
  revision 4

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5e76cebc3734d39273587f3d2d286b15bd1e869b03af84589987f9236062a1b3"
    sha256 monterey:      "0ed72c99749bdad72126577b8a8b09bc48a36757a12ba52834953af3636cba32"
    sha256 big_sur:       "13f4455b0065bdd06ef93f2be612884dbe9c2196834c0a9ad7d6c67d350759de"
    sha256 catalina:      "3baa9a70823b7b57ba43df65e54baf7dbd99e6b1615d7b15e22ac8af8746794f"
    sha256 mojave:        "f71005738d8026816e0407da56a98f06ac96f1ab7dc5e28b155b6a4b39942f46"
    sha256 x86_64_linux:  "d7d3a81f1cc361af9ad5e8408eb7592d346886eca0a6f81eeec80087131e6151"
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
