class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "f90c3b096af568438be7da52336784635a962c9822f10f98e5ad11ae8c7f5c64"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a79829da44dc03e12ea4977b6bfa122cea8487e741c24a7fbcc7ce6a4788db3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c8ce81f2d2e32e5d600c474c433cd67af71c7f95c4c9de0622369557d4667b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491753d73c724655595030aac15f675f3fe0240af8be73c673251b37a7a90017"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f05803354dc8621b9bdf918d50aef83eca450b90babc5b9899ca151177c39a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0b9a0eb7628a130fb45cd3a5abc08321daa6f48eb175e26f784ef44fa9a18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6cdec4cc985c9fdef714051f2c921b8d5158c444be11e73af825054589d0ddc"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "hyperfine.bash" => "hyperfine"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
    man1.install "doc/hyperfine.1"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
