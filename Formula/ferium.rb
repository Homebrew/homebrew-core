class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.2.0.tar.gz"
  sha256 "6f3fd6112686bf5afdc86102f3ede642dedab7e2d493921ce3acd79151bd68a4"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24deb5694dbb062543dc6b90e822096e749511db10326c96f5c0940a9862ffe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4bdbc18b75d868b158bd3a73aca64031299c2090a01cb91bbe93cec75ba1f61"
    sha256 cellar: :any_skip_relocation, monterey:       "fd5120a79f12d1b075f746cb3528e84b3646d5721e6ceb5f94a176d9d7dbc60f"
    sha256 cellar: :any_skip_relocation, big_sur:        "709ba0ec0d3a57922dc34696c7313fb88bc83b4b5a91255ed37dade8ea372713"
    sha256 cellar: :any_skip_relocation, catalina:       "cda21e75f57b5c76b4d58f4af0af1d76ff63c83dae6cff1827e0a50e8b148600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28477eff1fa21da1033f71274dcb36986542dc0753a94bb8d63a408354309618"
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
    system "ferium", "--help"
    ENV["FERIUM_CONFIG_FILE"] = testpath/"config.json"
    system "ferium", "profile", "create",
                     "--game-version", "1.19",
                     "--mod-loader", "quilt",
                     "--output-dir", testpath/"mods",
                     "--name", "test"
    system "ferium", "add", "sodium"
    system "ferium", "list", "--verbose"
    system "ferium", "upgrade"
    !Dir.glob("#{testpath}/mods/*.jar").empty?
  end
end
