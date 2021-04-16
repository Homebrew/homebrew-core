class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.33.0/maxwell-1.33.0.tar.gz"
  sha256 "319421729120c02266f7e83e6f9ad1910da182bbc5f4304766e53edb2b67e336"
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
    assert_match "ERROR Maxwell - SQLException: Communications link failure", File.read("#{testpath}/maxwell.log")
  end
end
