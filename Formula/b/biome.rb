class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.8.3.tar.gz"
  sha256 "8e263bbc1ff644036409471f10320870510025fa1850912a02b1abcfc92ced79"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14f285f035481e07f6b2ce128f5ebc74ddea146b71d9057c1175901edc6b9b17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ac096323e81dc12b926b1627207e0bf1c2ae4b48d7ff60eaff5e7b7a619aacc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab37a3f3b410aec94208e2f710a7c341eb95242280ff3ffb218a97d802811696"
    sha256 cellar: :any_skip_relocation, sonoma:         "132bf40be192b1dd674038c8a88456325b7a2981a4dcc22b4a216052f9a44b69"
    sha256 cellar: :any_skip_relocation, ventura:        "19929d7c4794786ec2cc7dd7d624558d75476991cfeef97a89b6e43e79670aef"
    sha256 cellar: :any_skip_relocation, monterey:       "60760380c50730f3c7a77786c95dc9a4f1bac945a3358f5b19504b7c42b1a458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630287008e3310981936b2c181e7e5d087028e5330354ce4d28ece2e70e76dd8"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end
