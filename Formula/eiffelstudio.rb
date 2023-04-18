class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/22.05/pp/PorterPackage_std_106302.tar"
  version "22.05.10.6302"
  sha256 "c2ede38b19cedead58a9e075cf79d6a4b113e049c0723fe9556c4f36ee68b80d"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f649798d11ada5d28576c801c4f9f3e5b73aae8e7b82ba73c502c4894e405415"
    sha256 cellar: :any,                 arm64_monterey: "7702a2a1ad36efe8571c676468582eacc949c64fbd785684e64adbb9613c394b"
    sha256 cellar: :any,                 arm64_big_sur:  "05891069a779e163414a4fb38126f81974375bb762a16391446efb7d8925213a"
    sha256 cellar: :any,                 ventura:        "e462d3c40cc95e39824936bd6365416bcd968a16c605acae501e1f68b8ba08e6"
    sha256 cellar: :any,                 monterey:       "7b93bd2cba3b0fd57de705bdce5d9f5d9602f12789468a067d40cafd2ab1a225"
    sha256 cellar: :any,                 big_sur:        "6f6cdc2480c8fd52baa606189ef7a7f381779655640bb84ce89c7651d52858c5"
    sha256 cellar: :any,                 catalina:       "b7ced66010ed23f1dbd4d25c959828188708924402a5e350e8858c235cfc7374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c2d59af7e2b897b4f5560f67a0818679a44542dcfb59f5a2c81cb74b45f980"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  uses_from_macos "pax" => :build

  def install
    # Fix flat namespace usage in C shared library.
    if OS.mac?
      system "tar", "xf", "c.tar.bz2"
      inreplace "C/CONFIGS/macosx-x86-64", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      system "tar", "cjf", "c.tar.bz2", "C"
    end

    # Use ENV.cc to link shared objects instead of directly invoking ld.
    # Reported upstream: https://support.eiffel.com/report_detail/19873.
    if OS.linux?
      system "tar", "xf", "c.tar.bz2"
      inreplace "C/CONFIGS/linux-x86-64", "sharedlink='ld'", "sharedlink='#{ENV.cc}'"
      inreplace "C/CONFIGS/linux-x86-64", "ldflags=\"-m elf_x86_64\"", "ldflags=''"
      system "tar", "cjf", "c.tar.bz2", "C"
    end

    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    os_tag = "#{os}-x86-64"
    system "./compile_exes", os_tag
    system "./make_images", os_tag
    prefix.install Dir["Eiffel_#{version.major}.#{version.minor.to_s.rjust(2, "0")}/*"]
    eiffel_env = { ISE_EIFFEL: prefix, ISE_PLATFORM: os_tag }
    {
      studio:       %w[ec ecb estudio finish_freezing],
      tools:        %w[compile_all iron syntax_updater],
      vision2_demo: %w[vision2_demo],
    }.each do |subdir, targets|
      targets.each do |target|
        (bin/target).write_env_script prefix/subdir.to_s/"spec"/os_tag/"bin"/target, eiffel_env
      end
    end
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system bin/"ec", "-version"
  end
end
