class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.13.3.tar.gz"
  sha256 "b2b6e48988abec12bba37ac9fb2f9a6777d28125c0ab2ac3be1d8659b8b7b9a5"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afae0f713c233f8e1656e05cc021440a3306792e726bba49289447c3adc5df6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afae0f713c233f8e1656e05cc021440a3306792e726bba49289447c3adc5df6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afae0f713c233f8e1656e05cc021440a3306792e726bba49289447c3adc5df6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "274653f8d98d942ef4409472e59ec90aae851700c4aa9a57918cf3ef151f7a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5610385c49a6b7075479f35eff8d0076fc5108ac9141475731904c7fbaa599d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6545959927e5b9cc09bbda16b73ec40ef2c1800bd3c2239edaa476520f2d245"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
