class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https://maxwells-daemon.io/"
  url "https://github.com/zendesk/maxwell/releases/download/v1.41.2/maxwell-1.41.2.tar.gz"
  sha256 "55f9c90b27e188f0804131e92628aa3262d3a70d2c3c22e41341dd32924ad5a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03871ea82d9bb31d8b94e330ca4cd56fb418c97a2798a50e3363b8e2f88b5db2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03871ea82d9bb31d8b94e330ca4cd56fb418c97a2798a50e3363b8e2f88b5db2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03871ea82d9bb31d8b94e330ca4cd56fb418c97a2798a50e3363b8e2f88b5db2"
    sha256 cellar: :any_skip_relocation, sonoma:         "03871ea82d9bb31d8b94e330ca4cd56fb418c97a2798a50e3363b8e2f88b5db2"
    sha256 cellar: :any_skip_relocation, ventura:        "03871ea82d9bb31d8b94e330ca4cd56fb418c97a2798a50e3363b8e2f88b5db2"
    sha256 cellar: :any_skip_relocation, monterey:       "03871ea82d9bb31d8b94e330ca4cd56fb418c97a2798a50e3363b8e2f88b5db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bdc4d7e80f49c298f7314682b8b2fada302b5237a6f3fb7d40abf72513444d2"
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
