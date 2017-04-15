class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.0.7.tar.gz"
  sha256 "9094071db178c1ba48bd3a0c957138c461190f28f3dc97c81a8d84d2233eb198"

  bottle do
    cellar :any_skip_relocation
    sha256 "ded3ed995804a6975db42aa3984dc559cea98696a4b9d2a659f09a472b4a78fe" => :sierra
    sha256 "e6a3308ead5d286ec2b53c3e3dbe82ce95b712eb106926eb0a75a16a19bc84ff" => :el_capitan
    sha256 "cbd107b9147e58be56405d04b83e7b58b2a61210f8713f32ef0aa12cc0cb9192" => :yosemite
    sha256 "81b380fb42b2f057f80842a723a30bee313ca6c7f70a9f007a206c63064ca665" => :mavericks
    sha256 "be677363eb1d07b255dd6d931b372411011576d97269f75c52dbb72a716ea919" => :mountain_lion
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
