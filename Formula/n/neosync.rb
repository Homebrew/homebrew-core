class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "5a098d775b7bf982cffe28649346741fdb5cfeb26b091b7cd3b58f06474ed631"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c9da357b7dae4a8fbd24c50a6da6e747765fd514aa46c9842d92dfcd754ca7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b07f7b825564878234671349623c5355091c079017fe92ba527601a257197bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cce69c1e2292009d8d3e60f30ba135e6fbe18268525082238e8b0ab8a0aaacd"
    sha256 cellar: :any_skip_relocation, sonoma:         "609de58d1a5e41a3bc5c62519f996c537c3ba90d809509391b75b5919e1f5e12"
    sha256 cellar: :any_skip_relocation, ventura:        "b29bcbe64bfad061983f9f019d9b32db553610fdaf6b66b44eac0fc744e5ff3a"
    sha256 cellar: :any_skip_relocation, monterey:       "821e3a83b1741d080c8f17b90b2f4c7322e4af19f062a46429dda19959413194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6443eb82e524fcffda85a1659b4ff54875b2b59244f2a02cd88974de4c3f5cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
