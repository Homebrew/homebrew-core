class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.1.10.tar.gz"
  sha256 "dda250ac5b7c248145f212b9aee1b3a23c88a137da3dd0b6e61a0e3b9f06fb06"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"ferium", "complete", "bash")
    (bash_completion/"ferium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"ferium", "complete", "zsh")
    (zsh_completion/"_ferium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"ferium", "complete", "fish")
    (fish_completion/"ferium.fish").write fish_output
  end

  test do
    with_env("FERIUM_CONFIG_FILE" => "./config.json") do
      system "ferium", "profile", "create",
        "--game-version", "1.19",
        "--mod-loader", "quilt",
        "--output-dir", "#{Dir.home}/mods",
        "--name", "test"
      system "ferium", "add", "sodium"
      system "ferium", "list", "--verbose"
      system "ferium", "upgrade"
    end
  end
end
