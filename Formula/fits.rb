class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.2.0.tar.gz"
  sha256 "54a557cd1e559b4473dbbdd6bab561911ffaf090dfba258fab79604b50c3a46b"

  bottle do
    cellar :any
    sha256 "9a6d083c8c70fb75240e94b9a05a4db864eb9de6f718e2ff98e5cbe6e87f094e" => :sierra
    sha256 "022efd61e0b8f100f30f84bb1223b6b6c28198bcc278721424fbfdf32a5c87d8" => :el_capitan
    sha256 "b8a7e8240957b2347a4a90dbd15c671b6610809b3b39b887b9231210bd1f0874" => :yosemite
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
