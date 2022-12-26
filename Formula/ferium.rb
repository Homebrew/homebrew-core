class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.3.0.tar.gz"
  sha256 "791d9136a6802b499b9065d80ddd6ec3af1305c597f078fffb1740a01beca4e3"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2f21d9d6edd15e8dea5355fa9c9571ca3d39aea864bc174a9f38937c07ea608"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99f4d4e58ddce0da56d46657a765bdd3b65fe9daa043480b17a5591cbec69136"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cacfea7b7da965c7d2edd92a1907bddc873e498d64bee7f4d529cb528817dc5"
    sha256 cellar: :any_skip_relocation, ventura:        "9a75a3d45d92080b10dba0a6c0028ea7d99eb2c5fe3d5ebe261dac2c7f21578d"
    sha256 cellar: :any_skip_relocation, monterey:       "57ee7bd1fec6a4206b9c89538b2ad44c63bfa8d3595e05ccf1b725c53f023be9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eac953745c0e8c63f84d7598e10346bb9abf3eec31585a56f66c254e2120f03"
    sha256 cellar: :any_skip_relocation, catalina:       "69095a1803e37c4d84f9fd14b849df9edf3f958be82248490d711daf54316ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b591aeda772509e4ae26d127144e1e9761e586901a0abc67a06be8401e6624e"
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
