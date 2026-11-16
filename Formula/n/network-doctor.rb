class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "3739b4e1a6686c381cb06af46988b6b9c9a3995822b1dd42363a0e66cffe3e8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5750681db82cdde0e8994d74c30792ee02fce37df035dbc907555ceb8e2f6a3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5750681db82cdde0e8994d74c30792ee02fce37df035dbc907555ceb8e2f6a3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5750681db82cdde0e8994d74c30792ee02fce37df035dbc907555ceb8e2f6a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae92d6081eb86c2b246ddcd275353309d1b756d6e5548629d21cc9715b6c122a"
    sha256 cellar: :any,                 x86_64_linux:      "10d4520aeadf18c0fcb455f75344c42641003f7fa6f55e975aad400616d40d4c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
