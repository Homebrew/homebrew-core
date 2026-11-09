class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.8.tar.gz"
  sha256 "39b3d8755bd809c0731e81d5a3b5a025704205de68d95e5a9dd1ea192482cbf7"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eaf84232280bf428292a637e0d147978ca7899d525bade7e3b4f791d61556821"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eaf84232280bf428292a637e0d147978ca7899d525bade7e3b4f791d61556821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eaf84232280bf428292a637e0d147978ca7899d525bade7e3b4f791d61556821"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "819563f088bd16838690e31bc2faa54194efc5baabc093bcc751685eca8ad481"
    sha256 cellar: :any,                 x86_64_linux:      "86ef01134bc6f03676bf927a30492a8a528aba285070919f6ca9a1943dc1a800"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end
