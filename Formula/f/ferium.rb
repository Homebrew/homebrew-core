class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "a7804e44d1949e3fe2c5e875d7d70fc6d2ecd16cbcb65619b9ad4f61ac3b1887"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d82961f18209d69cc4dbf752e085b70300d1fa370ef3d10cae0f56abcc3342b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b43b3cf699c980a5d05a89caee5f384b60275358d3921853974104991b1dc449"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be87cd871f574ed79b96b3b0cad43204e017f5edf10787621e1b11390070482"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a5aa67de799c8ed5c0df316937df94ed7918b88518f766adaab9b5ef70c0568"
    sha256 cellar: :any_skip_relocation, ventura:        "a318e9abd4668880ea2689f1f989bb0b4872b43fd9872e9cae82fe0f3702c960"
    sha256 cellar: :any_skip_relocation, monterey:       "0b8fa02e72985609b751aad3009af0958a28e3f7c6d1c8979c6bb0733f4d0915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7b04a325169dd91ab9c36360fb70a8524a5ec552f57985ee2c26b600526b96"
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
