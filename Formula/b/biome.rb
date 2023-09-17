class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.2.2.tar.gz"
  sha256 "744847d50e716a5ada7eea2f9862fdad6c5321c5aa3ad15c3169e170b2fa09e7"
  license "MIT"
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "541602aadf5477d9d7bba969d867adfc2967172a3ef1b92aacefde46304f2a98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89be6120d6731b8e61735e9ba5a6b3225da76aa281d5e2f4b27248a6be372f49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c23fe026c4f80ed608e6d60b760afccde5eb92f727ae59d35c7eadf567324d1"
    sha256 cellar: :any_skip_relocation, ventura:        "c3f2569e0ec60e73e5bdf78b7176272edfc128f64fc05944446bfd1f9c555c71"
    sha256 cellar: :any_skip_relocation, monterey:       "573d350b342d47ebef71c59d12d1de948756c9c5be5ae2820790712cf979b60d"
    sha256 cellar: :any_skip_relocation, big_sur:        "168bc4975dc9a59654b76f6b263aa74cf8b2b0feba003b1e0c33097b182fea49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb251f3e2f5c34ccc2ad02ecada2cf79d8bf76cfdb4cc2103a3202f02f0922e"
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

    assert_match(/cli:\s*#{Regexp.quote(version.to_s)}/i, shell_output("#{bin}/biome version"))
  end
end
