class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "a9b9fd966f47d5f8c32e483a21ea476f6883f194e7813f1f81b0001e14b046a5"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a58de2ac63160b743c382e37b8746d8dc1da9518e23fbf519156f56449dafa1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6790e976ab796a3eba9bdaf990d338a1ba9fd4dd9af9b95be83971b3c0f08662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be43fc9aea34e8c638cb352048c5d7b856f3af46d4d920e3717efb923ca1b41c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d6f4734fa8edd8de7f1583b4a35e2460e8d73830a734ea0f53bd1a720f3e71a"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bf54da7812220cc21c465ffa24dc296b6c7d96815712651a30ccf9fe10c540"
    sha256 cellar: :any_skip_relocation, ventura:       "4c14295cc97f603fb82fed856fb6695ec9f32e4b6473fb95cca6c0c2a10b80a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ffac93ceda25507df1070fd4adf9b52157285992d6224838eef9139c680b200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "139b6568724b1ff83342d0e33539425f3d0c74a34319e8bfbe17eecdb37f03f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ferium", "complete")
  end

  test do
    system bin/"ferium", "--help"
    ENV["FERIUM_CONFIG_FILE"] = testpath/"config.json"
    system bin/"ferium", "profile", "create",
                         "--game-version", "1.19",
                         "--mod-loader", "quilt",
                         "--output-dir", testpath/"mods",
                         "--name", "test"
    system bin/"ferium", "add", "sodium"
    system bin/"ferium", "list", "--verbose"
    system bin/"ferium", "upgrade"
    refute_empty testpath.glob("mods/*.jar")
  end
end
