class Maxwell < Formula
  desc "Maxwell's daemon, a mysql-to-json kafka producer"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.26.3/maxwell-1.26.3.tar.gz"
  sha256 "54d1785313f2ef9c1d0c1ba32e30d582ee9f506facd64b1770a86714e9021336"

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
