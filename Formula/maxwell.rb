class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.39.6/maxwell-1.39.6.tar.gz"
  sha256 "7e87add6104e4f4216c8788361f99f56184ebf84cd636b846c1f044a3199f776"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8e33c2ccad6059f229caf967aeeec0ae355cf124620931a368c47c7f174caee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab109330df7de6398dd695de212d7dcb4be8eb9f31f360eabc48278f41ad4328"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e511b623e634ed38d01d7f7e2c5b901c5da3d54ba54ecb6405b3129dda5fdc4"
    sha256 cellar: :any_skip_relocation, ventura:        "3319419239f6ee666ca7a85f4912144501a87084214024fb2d7341f2b50b8684"
    sha256 cellar: :any_skip_relocation, monterey:       "ab8797e4859c7f39b9b8143abbad5038a924868bf8d5182ec7e54c831544648c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed607c27704986c040a15ec6574d273464cfbd105aafd5c91f6ac494ea230e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8ab943f25ab35aa1cedabe67428f1919ae9ede6d9e8e1f5e9c102be591a460"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    %w[maxwell maxwell-bootstrap].each do |f|
      bin.install libexec/"bin/#{f}"
    end

    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11.0"))
  end

  test do
    log = testpath/"maxwell.log"

    fork do
      $stdout.reopen(log)
      $stderr.reopen(log)
      # Tell Maxwell to connect to a bogus host name so we don't actually connect to a local instance
      # The '.invalid' TLD is reserved as never to be installed as a valid TLD.
      exec "#{bin}/maxwell --host not.real.invalid"
    end
    sleep 15

    # Validate that we actually got in to Maxwell far enough to attempt to connect.
    assert_match "CommunicationsException: Communications link failure", log.read
  end
end
