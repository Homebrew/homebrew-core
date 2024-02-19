class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "b337f0a5884f1e1f6786417914e052ca08fea7e946e6977ccb68abe4fbcf09ee"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33e0f53ab4851ef6fffbf59dcaa5c721f2f8f8453353f69515768d01a119eb3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f419bebfe6434c81dd32274d229474e2eaf9bf9bedaff1e01326275e0691d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592c2eefb4ee642b9e00f16ccf0475db506dd7b0782ee8655a568ab138b743b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "049bb3346113eea921c8b04819745c3888770b011c483665b6976d28b234d4bd"
    sha256 cellar: :any_skip_relocation, ventura:        "19e0d66bea43cf73c4c2824d7e38fc46b9fa5f951afec33e5f81f4386a7318ab"
    sha256 cellar: :any_skip_relocation, monterey:       "3ccd453608596a470015bf948bb604d34d5b7c4e751e7323b543915b69ace53e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c901ed2ef41077a3d63de62da872d0aa5e76f422fb106e5fa6388c4441a6ba"
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
