class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.6.3.tar.gz"
  sha256 "a7172467bb0a15fa4c1138f5540493f8cb80297958b3d98ad80d18232cbb9537"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d82c78f68dca6c63a6db711867da14c351b504b203a8385f8cf007614364388"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7008166a004c39abb47a53a513d0d12b1a5369fdf1239d753d77440852903d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bde26debdfaf642484dbee84c7443a249a8fbd117001e7d1da4aa873e53ffa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b02a9eba668638c346760f5ce993e8a6ce5310c33bb8954d865007444f3094f7"
    sha256 cellar: :any_skip_relocation, ventura:        "3763f4041e1136671a8d5ae4689825ea92eb2ca071324b9e3a0fb101f5834e11"
    sha256 cellar: :any_skip_relocation, monterey:       "76ed74e237241940d982d933c5fc5c9693f69c18175feb60688ca3c9624a8d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c85e38799ad357bd68729b4716d95b1597b01f675c9fd6139ffeb856074278d0"
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
