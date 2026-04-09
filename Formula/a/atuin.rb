class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.13.6/source.tar.gz"
  sha256 "89d12e2b5b69a0cf47113a0e9c55edd297ca5393be11e616685d0b6567133acd"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e15aa9049021553fdd5051e717845e1e7f798857efe326f391c60ae780ff0215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf5ad6200343dcbbda30abc4e3729a632c398baa0c8b2cb0109c58bec135efa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0fbcd34d1e6c9b937fd6b3b20e6ba13ce066b86e4a0d32b20335b52876005f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14d6263b5e6557cf541271d19dfef08eaf62c0cb551a4e1f203882bf848383f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "665566958bd0395c3065b3f993c548fdcdd77db62b1c6e8480cc2c4a3506f4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c422239de7965ad6c848bdfd51fe0b280bfad3989975293a6fc84957d60fba7c"
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
