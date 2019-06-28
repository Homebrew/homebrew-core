class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/archive/1.2.1.tar.gz"
  sha256 "2cf9e39f7bf129d447ebe96a426d1d8dd1f1af9b1664b34e0918e9dc65c046bc"

  bottle do
    cellar :any
    sha256 "456aa46dc03d3ee38f4d6aa2a2c29f2aa3f0499eb2297d24b3c6ca0236742b14" => :mojave
    sha256 "7d6dd16320473df3523432254f211dc846f8002c72c805f336811d530de7df7f" => :high_sierra
    sha256 "89566466a165dfca0947c7686ed6559a202da46375344906625a0f0e4cf3a057" => :sierra
    sha256 "135d0c1a755ecb3cbd2277a789849eb0178f62e972de2e43ea4bfe1b14d17b26" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on :java => "1.7+"
  uses_from_macos "zlib"

  def install
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
