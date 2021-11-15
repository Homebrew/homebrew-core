class Blastem < Formula
  desc "Fast and accurate Genesis emulator"
  homepage "https://www.retrodev.com/blastem/"
  url "https://www.retrodev.com/repos/blastem/archive/v0.6.2.tar.gz"
  sha256 "d460632eff7e2753a0048f6bd18e97b9d7c415580c358365ff35ac64af30a452"
  license "GPL-3.0-or-later"
  revision 1
  head "https://www.retrodev.com/repos/blastem", using: :hg

  livecheck do
    url "https://www.retrodev.com/repos/blastem/json-tags"
    regex(/["']tag["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any, monterey:    "6f3f83fd9bc9b5a259eb21ea43bdc37e4d4a8665c809b8f34d456f681d3c1d17"
    sha256 cellar: :any, big_sur:     "003bbd7d1f5f9d81fb471d1fff692951c9400a8bf2f1511f0d83c9bea9cb8e63"
    sha256 cellar: :any, catalina:    "7b9652bffa8c28d6f23e1ad88534b5f2bbd49a916566650c3090366a556f11b2"
    sha256 cellar: :any, mojave:      "9972096dbef1b35d3d98894c77575a4fce7c674660498e0877b95fe22383f1eb"
    sha256 cellar: :any, high_sierra: "74e39ac321fe48f06927b3ac455a382f14342c007b06b083860175edca1e0062"
  end

  depends_on "freetype" => :build
  depends_on "gettext" => :build
  depends_on "jpeg" => :build
  depends_on "libpng" => :build
  depends_on "openjpeg" => :build
  depends_on "pkg-config" => :build
  depends_on "glew"
  depends_on :macos # Due to Python 2
  depends_on "sdl2"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/b3/d0/a20d8440b71adfbf133452d4f6e0fe80de2df7c2578c9b498fb812083383/Pillow-6.2.2.tar.gz"
    sha256 "db9ff0c251ed066d367f53b64827cc9e18ccea001b986d08c265e53625dab950"
  end

  resource "vasm" do
    url "http://phoenix.owl.de/tags/vasm1_8i.tar.gz"
    sha256 "9ae0b37bca11cae5cf00e4d47e7225737bdaec4028e4db2a501b4eca7df8639d"
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

      system "./configure", "LIBS=-lintl"

      # Avoid `touch` error from empty MANLINGUAS when building without NLS
      touch "manpo/manpages.pot"
      ENV.deparallelize { system "make", "manpo/manpages.pot" }
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
