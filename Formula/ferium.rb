class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.4.0.tar.gz"
  sha256 "a19b5ea7b12123ef68b2caf96a1c58025aa30d7e14e8c0dbfef44ffc01938045"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41864fed9cd78864371ae3957e0443d70dec7eacf9019a1eb197a57f2beddb8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26099947285062a1bf2d590142f3bc03603d20a48adf9af7ee7f355d553b4ac7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42bc3806194b768ef8fb9ffe48dd6e8afdd8c5d7869e22ec8eec1450ee390217"
    sha256 cellar: :any_skip_relocation, ventura:        "9be94f1405ba1b6101398a802ecbe013f3d8585073a36ff651c0ae0b44a6c545"
    sha256 cellar: :any_skip_relocation, monterey:       "11f11f640dd5572ac0a428a19c6fbe9590bd6d908556b2160ead9658b38e734b"
    sha256 cellar: :any_skip_relocation, big_sur:        "19c5e4ec44ec287ad128aa0d7c94746562bbcf6ff40a305d29cc13fb1b649822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9f7432669f021189175775c9520a8e0e0d450800b2193a6b77a684b09d050f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

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
    !Dir.glob("#{testpath}/mods/*.jar").empty?
  end
end
