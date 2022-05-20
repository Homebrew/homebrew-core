class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.14.0.tar.gz"
  sha256 "59018c22242dd2ad2bd5fb4a34c0524948b7921d02aa79419ccec4c1ffd3da14"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e64962c77b0387eb137dd42ed6c38dc0a4a610bb273b9f98c31be53f3ce5f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31b4e01149900865afa6f5687beb754a310502206239ff757dc6ce887d85655f"
    sha256 cellar: :any_skip_relocation, monterey:       "e9f20fa5e53757fdf3030470460bcd436584aa2ad1781b8405dbc8c5f6b93ec9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c3c41d5640e7a8a059720d9cb47ccf9c876e5c5c6c81151b0cf50dbcf3b8b7f"
    sha256 cellar: :any_skip_relocation, catalina:       "010f1150a75973eb265055af64412bb2f5a51ffbafc5ca122b8f45cd092b2b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f829610b0d1976c1bbd34aabb8c73eab362702b6045d3266bdcf970bb1fe487f"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
