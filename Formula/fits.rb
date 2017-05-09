class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.1.0.tar.gz"
  sha256 "57ba2ee001c2c113a1cae84d1c8f8e9a49e21fc39307abe2bd97de0a2c1689c0"

  bottle do
    cellar :any
    sha256 "93aab6671d4e0f1c7a9cae92f0cf6e37b0f15b434e08960c23466194c152e332" => :sierra
    sha256 "3e0ea5636546690b9f7a76cce7da6c31336f6c5f8acd7ad7923a090f2daaa038" => :el_capitan
    sha256 "53ba548aed7c8d6496521747f6c3810329c37306068dbf6aa897716c9a518b33" => :yosemite
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
    bin.install "fits.sh"
    bin.install "fits-ngserver.sh"
    bin.install_symlink bin/"fits.sh" => "fits"
    bin.install_symlink bin/"fits-ngserver.sh" => "fits-ngserver"
  end

  test do
    assert_match 'mimetype="audio/mpeg"',
      shell_output("#{bin}/fits -i #{test_fixtures "test.mp3"}")
  end
end
