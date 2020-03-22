class Blastem < Formula
  desc "Fast and accurate Genesis emulator"
  homepage "https://www.retrodev.com/blastem/"
  url "https://www.retrodev.com/repos/blastem/archive/v0.6.2.tar.gz"
  sha256 "d460632eff7e2753a0048f6bd18e97b9d7c415580c358365ff35ac64af30a452"
  head "https://www.retrodev.com/repos/blastem", :using => :hg

  bottle do
    cellar :any
    sha256 "6de87547192f1037defe587f9ee30ff32b2b5686067e330276163c700e1668ca" => :catalina
    sha256 "14193d951f4f115e618acbc95cb20e625c6fcc74ccb241f1f960c12f0655484c" => :mojave
    sha256 "841dc46c59d53256aeb619279b4bd8e4997810dc2832ee86fed9a41e056196b5" => :high_sierra
  end

  depends_on "freetype" => :build
  depends_on "jpeg" => :build
  depends_on "libpng" => :build # for xcftools
  depends_on "pkg-config" => :build
  depends_on "glew"
  depends_on "sdl2"
  uses_from_macos "python@2"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/5b/bb/cdc8086db1f15d0664dd22a62c69613cdc00f1dd430b5b19df1bea83f2a3/Pillow-6.2.1.tar.gz"
    sha256 "bf4e972a88f8841d8fdc6db1a75e0f8d763e66e3754b03006cbc3854d89f1cb1"
  end

  resource "vasm" do
    url "https://server.owl.de/~frank/tags/vasm1_8f.tar.gz"
    sha256 "9a97952951912b070a1b9118a466a3cd8024775be45266ede3f78b2f99ecc1f2"
  end

  resource "xcftools" do
    url "http://henning.makholm.net/xcftools/xcftools-1.0.7.tar.gz"
    sha256 "1ebf6d8405348600bc551712d9e4f7c33cc83e416804709f68d0700afde920a6"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    if MacOS.sdk_path_if_needed
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi" # libffi
    end

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "ZLIB_ROOT = None",
          "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None",
          "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None",
          "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      begin
        # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
        saved_sdkroot = ENV.delete "SDKROOT"
        unless MacOS::CLT.installed?
          ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
        end
        system "python", *Language::Python.setup_install_args(buildpath/"vendor")
      ensure
        ENV["SDKROOT"] = saved_sdkroot
      end
    end

    resource("vasm").stage do
      system "make", "CPU=m68k", "SYNTAX=mot"
      (buildpath/"tool").install "vasmm68k_mot"
    end

    # FIXME: xcftools is not in the core tap
    # https://github.com/Homebrew/homebrew-core/pull/1216
    resource("xcftools").stage do
      # Apply patch to build with libpng-1.5 or above
      # https://anonscm.debian.org/cgit/collab-maint/xcftools.git/commit/?id=c40088b82c6a788792aae4068ddc8458de313a9b
      inreplace "xcf2png.c", /png_(voidp|error_ptr)_NULL/, "NULL"

      system "./configure"

      # Avoid `touch` error from empty MANLINGUAS when building without NLS
      ENV.deparallelize
      touch "manpo/manpages.pot"
      system "make", "manpo/manpages.pot"
      touch "manpo/manpages.pot"
      system "make"
      (buildpath/"tool").install "xcf2png"
    end

    ENV.prepend_path "PATH", buildpath/"tool"

    system "make", "menu.bin"
    system "make"
    libexec.install %w[blastem default.cfg menu.bin rom.db shaders]
    bin.write_exec_script libexec/"blastem"
  end

  test do
    assert_equal "blastem #{version}", shell_output("#{bin}/blastem -b 1 -v").chomp
  end
end
