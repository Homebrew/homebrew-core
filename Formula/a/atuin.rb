class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.6.1.tar.gz"
  sha256 "aba26698471ef7ad2757416d01fcc327d3bd800c58cc3fcae638e625524e1b40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d5178502a1427a080827cf3b18c724afa3151658910e4596b33bb425789ce21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b16b97bed2dea1fdda46ce7416e2ada8af0fd6044a4911bbb46457f936fab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4d6d6af87adbf1ff6120766e30fdd4992dea765a7109f3d4ae83e9376e538bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c77f1e90366dd27311260f015f5d28f03e73a4be2d3401b20c77d489f5c9bf9"
    sha256 cellar: :any_skip_relocation, ventura:       "0d03abd8e58b7903113101ae29229d7b0537329519811034fd50f9e2c4fbfd94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcec8d144f1c8570dfe3f4625988f355292f440efc5dd3fcbdcd4c5335db282b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566e883860b1640f49f8cf6e642d2cd80611dcba9c6ac2821cc09a219139b73c"
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
