class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "aafb96d059cf9734da915dca4f5940c319d2e6b54e2ffb884332e9f5e820e6d7"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ab5efbab0f126407abb99caee68f658fbc25c3dc8a4733092d5b80ec343a18f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4116a95dea8bce74c52186d65ac1c7f62caa79e90233b467fb515457000937ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d32b581cadfef715868a99c40ae75e1e05da92b6febe7129c437df3ba7a1de6"
    sha256 cellar: :any,                 arm64_linux:       "f3d8fd4a2830d5febe53ef8ffb5328029907f5f94999a37b650566fbf8c07cb3"
    sha256 cellar: :any,                 x86_64_linux:      "3265210d4b40f7eb6e10af9faea95aba27a705ad5c71d202c8c7b3e59f339d57"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["BANDWHICH_GEN_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    bash_completion.install "bandwhich.bash" => "bandwhich"
    fish_completion.install "bandwhich.fish"
    zsh_completion.install "_bandwhich"
    pwsh_completion.install "_bandwhich.ps1"

    man1.install "bandwhich.1"
  end

  test do
    shell_output "#{bin}/bandwhich --interface bandwhich", 1
  end
end
