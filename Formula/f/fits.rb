class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/releases/download/1.6.0/fits-1.6.0.zip"
  sha256 "32e436effe7251c5b067ec3f02321d5baf4944b3f0d1010fb8ec42039d9e3b73"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "d71b24d9369f9b5737617ae4573432b87c30e8a465f433f6e99af6a78375cc09"
    sha256 cellar: :any, arm64_sequoia:  "34bbd71f26444e39865a8ae104c8371e2b549eba524b039fe08e69037063fe6e"
    sha256 cellar: :any, arm64_sonoma:   "e0b3cf87e22a873e51a2c746c7af622718b49caff51022a85724b84dc549e553"
    sha256 cellar: :any, arm64_ventura:  "83066fb495a516bd75b4d36e08b5861a0b1520d3803e650a111db6a235f73b12"
    sha256 cellar: :any, arm64_monterey: "83066fb495a516bd75b4d36e08b5861a0b1520d3803e650a111db6a235f73b12"
    sha256 cellar: :any, arm64_big_sur:  "9285f4607050a49b97d5a76565d75e706b5b376967eda49516e40aa0d8b1bdfe"
    sha256 cellar: :any, sonoma:         "4c775bd176df5777b6120f68b38684513455679064b96ac07f4c6e02afa8b4bf"
    sha256 cellar: :any, ventura:        "6113f4769d039c7e57371e31ddaf5acf0382a0f65d37232ae2aecb35ca3ec269"
    sha256 cellar: :any, monterey:       "6113f4769d039c7e57371e31ddaf5acf0382a0f65d37232ae2aecb35ca3ec269"
    sha256 cellar: :any, big_sur:        "6113f4769d039c7e57371e31ddaf5acf0382a0f65d37232ae2aecb35ca3ec269"
  end

  depends_on "exiftool"
  depends_on "libmediainfo"
  # Installs pre-built .so files linking to system zlib
  depends_on :macos
  depends_on "openjdk"

  def install
    # Remove Windows, PPC, and 32-bit Linux binaries
    %w[macho elf exe dylib].each do |ext|
      (buildpath/"tools/exiftool/perl/t/images/EXE.#{ext}").unlink
    end

    # Remove Windows-only directories
    %w[exiftool/windows file_utility_windows mediainfo/windows].each do |dir|
      rm_r(buildpath/"tools"/dir)
    end

    libexec.install "lib", "tools", "xml", *buildpath.glob("*.properties")

    inreplace "fits-env.sh" do |s|
      s.gsub!(/^FITS_HOME=.*/, "FITS_HOME=#{libexec}")
      s.gsub! "${FITS_HOME}/lib", "#{libexec}/lib"
    end

    inreplace %w[fits.sh fits-ngserver.sh],
              %r{\$\(dirname .*\)/fits-env\.sh}, "#{libexec}/fits-env.sh"

    # fits-env.sh is a helper script that sets up environment
    # variables, so we want to tuck this away in libexec
    libexec.install "fits-env.sh"
    (libexec/"bin").install %w[fits.sh fits-ngserver.sh]
    (bin/"fits").write_env_script libexec/"bin/fits.sh", Language::Java.overridable_java_home_env
    (bin/"fits-ngserver").write_env_script libexec/"bin/fits.sh", Language::Java.overridable_java_home_env

    # Replace universal binaries with their native slices (for `libmediainfo.dylib`)
    deuniversalize_machos
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    assert_match 'mimetype="audio/mpeg"', shell_output("#{bin}/fits -i test.mp3")
  end
end
