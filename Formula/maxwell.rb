class Maxwell < Formula
  desc "Maxwell's daemon, a mysql-to-json kafka producer"
  homepage "http://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.19.1/maxwell-1.19.1.tar.gz"
  sha256 "24fab4f189b52959497381ec1ed4ac2937e5cd2855de26061e476776d27d980b"

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
