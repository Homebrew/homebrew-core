class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.14.0",
      revision: "3f85048ecc6cc1c398eee9d311a5887da8d7eefd"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b93b737116f91eb946d3aceeb1bee33adab210ff9de6b424e52952a50cc1c0e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a67acf8c40bd9144f1b771cf86b303c640f48d5fefede770d003bc6f070c3a1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10fb3b1875b635979b47353536c42a12b7246bb46752346d65e56c8a07476412"
    sha256 cellar: :any_skip_relocation, ventura:        "1a3325bf1813e5f1e6670ae70dd2fc337b53be7b997840e9b6e4db212fa4f73c"
    sha256 cellar: :any_skip_relocation, monterey:       "c33f193aef55b4f7c8fe81102d9caa2649aa372682902d4c6613e5c66e39d947"
    sha256 cellar: :any_skip_relocation, big_sur:        "97ffa3ed529eaf8a29b601947bc75d2e56a437502e126aa71d9e461ae6e2fada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df645aa4cc3dc4f6b968107cc3dbac573fa94629c9b1b653a1c7044e3de6a89a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
