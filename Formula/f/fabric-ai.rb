class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.584.tar.gz"
  sha256 "49ffd4dfa3e141592193112352a64832e385db585f1c8b6ea053324becf50afd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    manifest_sha256 "5db30c09f4579eacf0ba36fe6b7c23424171772466cf826d4d96d94cb4d8280d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "463749a105808d616fe08cbe87baa65ae5bd9568611b18d22ee5cb45b5b27a4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "463749a105808d616fe08cbe87baa65ae5bd9568611b18d22ee5cb45b5b27a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "463749a105808d616fe08cbe87baa65ae5bd9568611b18d22ee5cb45b5b27a4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a6139f5fbb340127d2579ebb71ad246be7187ce5e7e323c2c879fecfe16d777"
    sha256 cellar: :any,                 x86_64_linux:      "5392cf3c3d56d0f3023fc54280a11102fe6644d92b55467433447094a53461d5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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
