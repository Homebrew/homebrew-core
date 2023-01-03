class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.3.3.tar.gz"
  sha256 "32cdf085a86e6a00c58b5c3005b5019d9bb711d79e77d910ea473c22ddad99f8"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4a775ac6e681881fd1cd12249a45ccab6f2c0fca85cf0190823edd7fe222941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7486b22b7613a3e1fd1d4343d3d7245a731666dbdf62c60bb456dbe9cc8514"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "929b40a9ba30ae9bcce0d1da93e2dd2441b8334c2c4a28c8c744c9f4dc9756b2"
    sha256 cellar: :any_skip_relocation, ventura:        "39f472afff8525e3879d1b8b4fc3c9f567ce79d7e4dc6ae6b069fa1c9e491993"
    sha256 cellar: :any_skip_relocation, monterey:       "e9f078f3d4bf35b2735e73840f1cf490f375c3c040099000a7bba6d3270f8c9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba25b616c3bab3451f2588053fdd0d6d1dc01953918c70a0cfe9e1553ad8cb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890098dc060f10f7d052ed3002e5f331508329c31f9baef660347fa95b98e0c4"
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
