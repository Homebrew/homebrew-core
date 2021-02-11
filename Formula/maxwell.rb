class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.31.0/maxwell-1.31.0.tar.gz"
  sha256 "e57a9523ae9625df2b07dff5cf7dca7548d66037bbbf4bf3f9a9c2a01d98d3e4"
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
