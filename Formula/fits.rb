class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.2.0.tar.gz"
  sha256 "54a557cd1e559b4473dbbdd6bab561911ffaf090dfba258fab79604b50c3a46b"

  bottle do
    cellar :any
    sha256 "fd792587001bce49cd0fbe5633a3186929e0acc220f0479f111081fdacf2acce" => :sierra
    sha256 "b3a8fd54515d275b0abc18c700787b701b01aa1f773c1b08354d28909dc8eb76" => :el_capitan
    sha256 "e44149423edebe64d2ba1e4002b3bb2b2b7c37e090bf26bda8e39bdbed4fde05" => :yosemite
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
