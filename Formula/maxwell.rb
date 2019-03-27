class Maxwell < Formula
  desc "Maxwell's daemon, a mysql-to-json kafka producer"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.21.0/maxwell-1.21.0.tar.gz"
  sha256 "aef435dc4c4ef053d3d74b5e528dd7515ebb15cd2bf0c5a35640d6ed807687fe"

  bottle :unneeded

  depends_on :java => "1.8"

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
    assert_match "Using kafka version", IO.read("#{testpath}/maxwell.log")
  end
end
