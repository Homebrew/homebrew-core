class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.6.0.tar.gz"
  sha256 "8b4e8dc87affa5a1e99dfc90fa0ee34232e34b7bcb9e7b4cbd51c23ecb6a3cc2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a0d3718802ac6bd22c2b83cae10c00d2825065d3e77c6ae1e112280b6ba3543"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f70f4e140f866e37dbd375cf115a2d9371dfcc861f853905205b78770d1e83a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "762e0099e2f591d33c41a9e0046ea88478b9a194f52b3582891c1a7480495da1"
    sha256 cellar: :any_skip_relocation, sonoma:         "01b56de38fe032b2b7bac8b62d2e4aa280307ec94c8b2abe102839098eea8d20"
    sha256 cellar: :any_skip_relocation, ventura:        "11c8376d03844f6521afbfcaf726d6e637fd35cba0736ab0cbb88b53586b3768"
    sha256 cellar: :any_skip_relocation, monterey:       "f2878e9388655bf489763d5fd9e21b10fa3f2499f2c4eb69c21dc93f8d556ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eff4eee31d4437275876db82e1130c9a242632dfef87da6bb7b01553f5d1ee0"
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
