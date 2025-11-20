class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.10.0.tar.gz"
  sha256 "02228929976142f63b4464a35b8b29b29155e1814cf03e99c95381954c5d9e37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235d017cc3111495c86fbc1d312474ac34bef3b437f87d06f863e0c9958be678"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd0573a397e6971a1425c76bf1704e32aa1236d573c0fe0af9ad864cd153aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2291c61ea446650b01fa0ea5015f5d8b2552735fdba7613d032cfdde341e7078"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9b90ff44ced78f53e2365435c0f168d4aa2218b8da2146c4354a5049a9905e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1f59232ac04c3d7be883f9d65f7100a2209fca0a5e7b99206a24b2aa949a54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82a016cbd0456b8af46f94f87e6e4ff178e5143363d4fb02958a83b110b8fbdd"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
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
