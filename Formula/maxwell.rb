class Maxwell < Formula
  desc "Maxwell's daemon, a mysql-to-json kafka producer"
  homepage "http://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.13.1/maxwell-1.13.1.tar.gz"
  sha256 "3ab7489d47f2ec04677122c8786cf573572b9bbb511b184802d2dcfe82e83781"

  bottle do
    cellar :any
    sha256 "3ab7489d47f2ec04677122c8786cf573572b9bbb511b184802d2dcfe82e83781" => :high_sierra
    sha256 "3ab7489d47f2ec04677122c8786cf573572b9bbb511b184802d2dcfe82e83781" => :sierra
    sha256 "3ab7489d47f2ec04677122c8786cf573572b9bbb511b184802d2dcfe82e83781" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  pour_bottle? do
    reason "The bottle requires Java 1.8."
    satisfy { quiet_system("/usr/libexec/java_home --version 1.8 --failfast") }
  end

  def install
    libexec.install Dir["*"]

    %w[maxwell maxwell-bootstrap].each do |f|
      bin.install libexec/"bin/#{f}"
    end

    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    fork do
      exec "#{bin}/maxwell --log_level=OFF > #{testpath}/maxwell.log 2>/dev/null"
    end
    sleep 15
    assert_match /Using kafka version/, IO.read("#{testpath}/maxwell.log")
  end
end
