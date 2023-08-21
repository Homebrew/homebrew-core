class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.4.1.tar.gz"
  sha256 "ccab09df5cd0c3db890b7099705696cd8770dcf936182dcd266ad3da5f5262f9"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f37d4d16cc4f144a688bee01253b3115f412929bd331f92815e4a5134a5e21c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "793976cca8e19041d852511fa0b09880fa9abc15dc9ff26515a774f288bba698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee52e909c8f01f336bd7a772f76c7a07d4dadd99320848dcc0f410bb50d365d6"
    sha256 cellar: :any_skip_relocation, ventura:        "653171bd67cb1585c6cc1ebb29485ee32926edefd869df3df0a02079848ef441"
    sha256 cellar: :any_skip_relocation, monterey:       "ba2efdf88c06c3bf569eb7531ad04090a6fa6884fc37001b932ac1cb35cb288d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e57f48928fc0296967408ca84abe5cbecdc50759bca3a6d328ba612bf812615c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ebd6659f1be5b9f228bcd17c8d7d6ccf86e61a498d624e0ced9d92b890bd468"
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
