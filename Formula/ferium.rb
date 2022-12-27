class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.3.1.tar.gz"
  sha256 "5b9ec07a97c0711fe66f990395f198941333783eefb56f3c2692646c13cf3a77"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd896173b1fa21451d4d9010947a4e41d062f82aba76f2e16e41d91751f79eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df85c38589cea685d18e0ca657324321c21edc28ea26ce03e10eabf1f5c2d75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aab55aa8a99a677ac437dcdcb95be76ddbf890a4740e3d9520ed070417d0cef7"
    sha256 cellar: :any_skip_relocation, ventura:        "6e5a8a207e9ee597b8d55104ec6d504ce70b8ba4b145a830f9ca65c761afe282"
    sha256 cellar: :any_skip_relocation, monterey:       "3830bad0a41d976e719f4d9fa3dce69a0a2c3fa452af7dc1636444893a76e2b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfcbe27dd586423ce1fb9ff79dd27ed480dda08bb1c92861d3df0ca9114579c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7167b7db77c75a99e89d5c937bd75c528904dc6dc7d262a54d815bec328f28"
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
