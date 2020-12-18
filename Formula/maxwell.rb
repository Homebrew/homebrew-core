class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.29.0/maxwell-1.29.0.tar.gz"
  sha256 "e5a071f8369179e92cba295daca9a13d19141975b0cde6db26b9a96981a1edd6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle :unneeded

  depends_on "openjdk@8"

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
