class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/22.05/pp/PorterPackage_std_106302.tar"
  version "22.05.10.6302"
  sha256 "c2ede38b19cedead58a9e075cf79d6a4b113e049c0723fe9556c4f36ee68b80d"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://ftp.eiffel.com/pub/download/latest/pp/"
    regex(/href=.*?PorterPackage[._-]std[._-]v?(\d+(?:[._-]\d+)+).t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb80572a9f45330718c9d37480bf5dd883654e1fef524447d828558d3fa86223"
    sha256 cellar: :any,                 arm64_ventura:  "13f283babf97160d03bd4793575262df0d96abccbab80a0e23749c43c72b2000"
    sha256 cellar: :any,                 arm64_monterey: "b38d768b91d114b8e1fcc2f010043ded8d4fafaec9858b1523044d33d3c78331"
    sha256 cellar: :any,                 sonoma:         "c431ca8133ea66b0ca7d454c9df091cbbfe49919452eff177bcb60ef2704de05"
    sha256 cellar: :any,                 ventura:        "b9e26ab5cd7c6743642b95b88062306a61e1347daa3cb78d986f8b66d770765b"
    sha256 cellar: :any,                 monterey:       "94244ccd7e1fcb3c01386840912cc5a1e0b57e54431493b40a57b2258e05963d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8570d391bf49d1208347ae385debef2ef5b3156a338417ecfa8b05610ee4ad"
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
