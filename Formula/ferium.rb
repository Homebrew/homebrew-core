class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.3.3.tar.gz"
  sha256 "32cdf085a86e6a00c58b5c3005b5019d9bb711d79e77d910ea473c22ddad99f8"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2186a5ab83d5df6b9491b17a604f6c5d5ec89979264f66fae37882d7f45fade6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a90185e0d1bce40e35051216ca6739988d1a5aabc3562ecbfa59b426d2a5886b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a52320510641d3cff9ed3e3c5c179bcf8fef76608ef49d16804282b7d0e55d"
    sha256 cellar: :any_skip_relocation, ventura:        "e69c9c741e17cf69596694f730e2651c43300aafe7af48ec2d191e068aa11f1c"
    sha256 cellar: :any_skip_relocation, monterey:       "d9647c9fcf66a890dba69a125c98f5152015ac8e703ec79dd2da5c2670da7643"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a4a5b1c081a3c35e804411e8da789aeca35c35a8ce6de052d01cbfd5c32cd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb06594beb9ecfc81af7ab97edebbf9ff81041dfb95a3565875b63c8e2a8ee5"
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
