class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.22.0/source.tar.gz"
  sha256 "46f9d940105791b09d870ca87e8952190dc69f968ea0036502a43840f83a56a0"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36bcdf51929806d9ac8308fda1dafe4d128b39c4fa7249c46313e3134ad81fc3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08b41ecb401bc825a26b86850a7a3199b56292866e0db3dc048b632267cc24ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68a41c4fe6269de733483192666f51d1fc435a2130e768bf45b2b5cfecc03630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ccf9d4a21490dfe4f165f7221a5ea0be578d8ed7d68123d6d45a6152d2b436fd"
    sha256 cellar: :any,                 arm64_linux:       "4ed18f8b2b73872f82ce7f9cefc569e43051eb5ced8191f45ea2001808ae83e4"
    sha256 cellar: :any,                 x86_64_linux:      "853bf72c33922f42bfdebe79eb56ea1355c82a19df306d36416ec2637f07c1f3"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
