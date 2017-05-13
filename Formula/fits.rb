class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.1.0.tar.gz"
  sha256 "57ba2ee001c2c113a1cae84d1c8f8e9a49e21fc39307abe2bd97de0a2c1689c0"
  revision 1

  bottle do
    cellar :any
    sha256 "e9c4804b16a628a72f546e3d33361ecfc19d3baf779992a52f6a9685f4ecfdb3" => :sierra
    sha256 "8f54130183f2c98d4ef07510891fa78fc6ced0761a4237c360e71f614da3dc14" => :el_capitan
    sha256 "4ad20c354f89507a904707a8bb66c40496904f31d5ad4043e0d410341f927a70" => :yosemite
  end

  depends_on "ant" => :build
  depends_on :java => "1.7+"

  def install
    ENV.java_cache
    system "ant", "clean-compile-jar", "-noinput"

    libexec.install "lib",
                    %w[tools xml],
                    Dir["*.properties"]

    (libexec/"lib").install "lib-fits/fits-#{version}.jar"

    inreplace "fits-env.sh" do |s|
      s.gsub! /^FITS_HOME=.*/, "FITS_HOME=#{libexec}"
      s.gsub! "${FITS_HOME}/lib", libexec/"lib"
    end

    inreplace %w[fits.sh fits-ngserver.sh],
              %r{\$\(dirname .*\)\/fits-env\.sh}, "#{libexec}/fits-env.sh"

    # fits-env.sh is a helper script that sets up environment
    # variables, so we want to tuck this away in libexec
    libexec.install "fits-env.sh"
    bin.install "fits.sh", "fits-ngserver.sh"
    bin.install_symlink bin/"fits.sh" => "fits"
    bin.install_symlink bin/"fits-ngserver.sh" => "fits-ngserver"
  end

  test do
    assert_match 'mimetype="audio/mpeg"',
      shell_output("#{bin}/fits -i #{test_fixtures "test.mp3"}")
  end
end
