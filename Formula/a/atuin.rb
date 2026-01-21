class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.11.0/source.tar.gz"
  sha256 "9435d2dd2469e1eeab0c0dc80425b35c51b286ba4e4ed36914c9813c2a54f4e0"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "197e5c97c187a6f5166018ff5e1d420c93ef8cf5cc8ed142c8f76d464332d053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a2297772a1ec141f18b51abb7206d622074f20dd65e42448b01e707dc2685b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f7589e4bf1653415750efc38c4894a2d1ac00f539b8ebec7b4517c67f9fc76"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eb9e19123be969842edde25beed354e84d433574d5c506cb43396814d8e4fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea0075eaa08b4ef8eec9855616354f7766b936951d778fac5cd2a6dc845a2e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e9571790d1fea8cc778542673c6f2d22316cecd3f8d247ee00d7befab61a79a"
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
