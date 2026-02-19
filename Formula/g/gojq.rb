class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.18",
      revision: "fa534a1318dedcd136563575e4a5b40fa8d47643"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37bd8446bdc2eb465ae15f4b129bd4cb6f73dbc7914f7f9e8e1703a780ded75d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37bd8446bdc2eb465ae15f4b129bd4cb6f73dbc7914f7f9e8e1703a780ded75d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37bd8446bdc2eb465ae15f4b129bd4cb6f73dbc7914f7f9e8e1703a780ded75d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eb951c058b4d2e9db22cebd674de96566738a1e463b366da147881531fc079f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb21b47235b018293a5167d7b2a5fd9f2a6540106bff1cb6a9f6b3bb81914c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d71e4f7a10b1d7bcc818f4dcd3b364a5bb4d86948ecddbb4cdbac66b6da5c4"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.com/itchyny/gojq/cli.revision=#{revision}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end
