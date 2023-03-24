class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.4.0.tar.gz"
  sha256 "a19b5ea7b12123ef68b2caf96a1c58025aa30d7e14e8c0dbfef44ffc01938045"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b531b8a451f6c3ee55bb64ff5b2ab3b9439f558d3ca30b53421062a1fecd98e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36855db44a1442c8581da48d23968bd2b15c989325860c5e789050af83abf7e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e25626850f7fb2849bc179c95655b90f6ce75884e1f94ada5dfc06d02abfb4"
    sha256 cellar: :any_skip_relocation, ventura:        "ef8f9c6e5a01eb396e8348cb270028c5ef5a3f88c29088ba84d4f3590ce5f980"
    sha256 cellar: :any_skip_relocation, monterey:       "829c91da73767d09167cc6b22e2113471dc5067966766c6e6c34519ccdf54022"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc078bdd9f079ff809f9aa2cb957257860a25ea47ef9717fe7c896ce868ee182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a0c5d0f77e8208face364aacc028fe89e5c114797d1b8453bdd51ed493ac49"
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
