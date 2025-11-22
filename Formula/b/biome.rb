class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.7.tar.gz"
  sha256 "42d2787840425ecc36d673ceff87d0a09557b126317dbafad4fc70fbab3e4a3c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2273259f4845b070b863be2cb8b217c97abffeafe906c35b087cd226774e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "103b57ae296ee3a9fcc83aa83b1e42a7d21d081e7b5ce6d754864ed97fd7c5c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ce096681edffa5376bf7c6bd56b9dc691ade7266f579304e8db72f8a004e3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5190be7313a63389f97539be96172abb8f371d4221ce4f18cb3220b627e0e3a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3d6de40bc7cc7caf60c23cd5f3840a853f4915bc423091aedb252de25387f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f8e8b7638bead97cdbf9cc943e5fa143a8ed54b0bf2cd6735fc3e7e12e6565"
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
