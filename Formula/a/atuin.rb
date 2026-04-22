class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.15.2/source.tar.gz"
  sha256 "ede9b9640392c8688f22ab0e252de3b2b047dd0824c62d31a32c7462ddcb56aa"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a0822467028783b2b58cc9a7900f11ee799bbf834940e19e5f1cf98c44c0447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "486353498b054fb114fef3f21ccf947486ec2d8ba7c9b82ce9e12af1acf6b78f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22f319cd86f026a24d777d5ec7e5b2b01b18e84e7d2e3b948cce388ade574238"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe3b4675efe30ac806618927a5af6c03d811f0571a8b197bec5d2b67d4f6528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6d98e87b523b7be810d87135260c0f42634b42d29686ee8e5078024b731f81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7c41f4c474ef29b7f39433be2847af263f9a86029cffe9328ea7321048bf2e"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
