class Maxwell < Formula
  desc "Maxwell's daemon, a mysql-to-json kafka producer"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.26.2/maxwell-1.26.2.tar.gz"
  sha256 "05a69932f786240df088a8ed3a420ffefd06fcba3424a7220a722b42ce0804f0"

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
