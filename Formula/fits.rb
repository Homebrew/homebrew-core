class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.1.0.tar.gz"
  sha256 "57ba2ee001c2c113a1cae84d1c8f8e9a49e21fc39307abe2bd97de0a2c1689c0"

  bottle do
    cellar :any
    sha256 "6e40f1fd9f8f1942695e0d40a6c6ba0a8c3ed742fc3fb463600617457a62eccb" => :sierra
    sha256 "2bfd30983cebe22bef49a889e4af586158f3b8f2ea9bc0f9560aa359a27ebf62" => :el_capitan
    sha256 "14f8f42715e72893d27ac1e6d3941dc5eec0b77e3838becb86475c70643a1522" => :yosemite
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
    bin.install "fits.sh" => "fits"
    bin.install "fits-ngserver.sh" => "fits-ngserver"
  end

  test do
    assert_match 'mimetype="audio/mpeg"',
      shell_output("#{bin}/fits -i #{test_fixtures "test.mp3"}")
  end
end
