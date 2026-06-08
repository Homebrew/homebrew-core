class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.16.1/source.tar.gz"
  sha256 "aec5c91207f080becc4b13593d5b7edc46685e8d4dbfbaef33d31f8058191bc6"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c0a9028714c42a158eedafd0e3c616f1e6df335f5e2fe3d4796006d8996d5db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aabe5a89f5f07effa9b1d93087469c60e3630bbb1f1eef4b4f3e8e63b8c1790b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "409a9e05765cda4f7271eaaa7833afb7d5ad55b71badac5b6459aa78cb85ee0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb8239444b8ce96d114812593e5781d141406097b8348bcf0d5b5ab11619fd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5edbd418eb0f9d32dedfa1c737e8e66487dd2bc81f02d31d27a807070dc6c7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51817c931148502c0ba47dbdb24359642c402c5d1697765a482489a5eb8955d6"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
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
