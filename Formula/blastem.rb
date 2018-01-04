class Blastem < Formula
  desc "Fast and accurate Genesis emulator"
  homepage "https://www.retrodev.com/blastem/"
  url "https://www.retrodev.com/repos/blastem/archive/3d48cb0c28be.tar.gz"
  version "0.5.1"
  sha256 "1929e39179ef46fd6b43b0bfd8f51dff29fc4ec001bd2e53811579707f5d9f1f"
  head "https://www.retrodev.com/repos/blastem", :using => :hg

  bottle do
    cellar :any
    sha256 "950fdcccc00508c7648fb2df90267bf5a9a2bf1844f00a14e320ec274c9c30bd" => :high_sierra
    sha256 "530e0fbfb551845ed326faa4942da3e4516b4fb77885f8a8cc7e99a40c2f179e" => :sierra
    sha256 "572a00653d2a1c8d51ba5ae77d1ad0bddbcc69e9f535c594f334d73176d09f5b" => :el_capitan
  end

  depends_on "freetype" => :build
  depends_on "jpeg" => :build
  depends_on "libpng" => :build # for xcftools
  depends_on "pkg-config" => :build
  depends_on "glew"
  depends_on "sdl2"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/8d/80/eca7a2d1a3c2dafb960f32f844d570de988e609f5fd17de92e1cf6a01b0a/Pillow-4.0.0.tar.gz"
    sha256 "ee26d2d7e7e300f76ba7b796014c04011394d0c4a5ed9a288264a3e443abca50"
  end

  resource "vasm" do
    url "http://server.owl.de/~frank/tags/vasm1_7e.tar.gz"
    sha256 "2878c9c62bd7b33379111a66649f6de7f9267568946c097ffb7c08f0acd0df92"
  end

  resource "xcftools" do
    url "http://henning.makholm.net/xcftools/xcftools-1.0.7.tar.gz"
    sha256 "1ebf6d8405348600bc551712d9e4f7c33cc83e416804709f68d0700afde920a6"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    unless MacOS::CLT.installed?
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi" # libffi
    end

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS::CLT.installed? ? "" : MacOS.sdk_path
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      begin
        # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
        saved_sdkroot = ENV.delete "SDKROOT"
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
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
