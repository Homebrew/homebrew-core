class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip"
  sha256 "1378a78892db103b3a00e45c510b58c70e19a1a401b3720ff4d64a51438bfe0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "18ae09e9e92d45f14502dd3b7a5323be6f1b1ac19fb45fd1c367b2417d9db929"
    sha256 cellar: :any, monterey:      "6e700d2bab8e41963162e6ac180628f4e9311ed71cae5a3034c756a17628be89"
    sha256 cellar: :any, big_sur:       "70a94bc9728e70e82c57d726ec958880da89dd5af6c2d65ae4351e6cf7543366"
    sha256 cellar: :any, catalina:      "70a94bc9728e70e82c57d726ec958880da89dd5af6c2d65ae4351e6cf7543366"
    sha256 cellar: :any, mojave:        "70a94bc9728e70e82c57d726ec958880da89dd5af6c2d65ae4351e6cf7543366"
  end

  # Installs pre-built x86_64 binaries
  depends_on arch: :x86_64
  depends_on "openjdk"

  uses_from_macos "zlib"

  def install
    # Remove Windows, PPC, and 32-bit Linux binaries
    %w[macho elf exe].each do |ext|
      (buildpath/"tools/exiftool/perl/t/images/EXE.#{ext}").unlink
    end

    # Remove Windows-only directories
    %w[exiftool/windows file_utility_windows mediainfo/windows].each do |dir|
      (buildpath/"tools"/dir).rmtree
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
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    assert_match 'mimetype="audio/mpeg"', shell_output("#{bin}/fits -i test.mp3")
  end
end
