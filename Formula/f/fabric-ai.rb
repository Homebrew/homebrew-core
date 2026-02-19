class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.413.tar.gz"
  sha256 "9468cd43962a756257cd3c48a17ffb3328ded6512221a1e55902539c9660e9e6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "225a3eb6d8aa7546aab758c6db572d49a53581e8e28814a888f212c7fd88cd81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225a3eb6d8aa7546aab758c6db572d49a53581e8e28814a888f212c7fd88cd81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225a3eb6d8aa7546aab758c6db572d49a53581e8e28814a888f212c7fd88cd81"
    sha256 cellar: :any_skip_relocation, sonoma:        "3373283e8da76a2d418653d58c89cfbf0568d2ea77880271d0ce6671df7a777a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a5886c5bb1745960e7d91683a680c32eac726142dd334d22023cda030a5c902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a3dadf204913236eb6fdf9c5911c5e44cd2077a3adf135ea3b6388777896b6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
