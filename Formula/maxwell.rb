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

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    %w[maxwell maxwell-bootstrap].each do |f|
      bin.install libexec/"bin/#{f}"
    end

    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11.0"))
  end

  test do
    fork do
      # Tell Maxwell to connect to a bogus host name so we don't actually connect to a local instance
      # The '.invalid' TLD is reserved as never to be installed as a valid TLD.
      exec "#{bin}/maxwell --host not.real.invalid > #{testpath}/maxwell.log 2>&1"
    end
    sleep 15

    # Validate that we actually got in to Maxwell far enough to attempt to connect.
    assert_match "ERROR Maxwell - SQLException: Communications link failure", IO.read("#{testpath}/maxwell.log")
  end
end
