class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "4e1d6e34c50fdeeb98e7d49d2e7164348c9395f5327920468ede0c32eb12adff"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dfffa83e0b66a22702b543ad5f55648e02e92b479924f488d447df36d1f13b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfffa83e0b66a22702b543ad5f55648e02e92b479924f488d447df36d1f13b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dfffa83e0b66a22702b543ad5f55648e02e92b479924f488d447df36d1f13b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd9fe716f75539fa90f1703974e88587235c1480c4965812551f2cd9533fb099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea3549974673835520c900004bcc822ed67822f13e813d14ef48fd0f9d37367c"
    sha256 cellar: :any,                 x86_64_linux:  "29be9e66fbd194161d2c8aa537888a97f7fca555860be213cb9847341a252257"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "determine target hostname for TLS verification: reverse lookup 203.0.113.1", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
