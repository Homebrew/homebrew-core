class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.1.tar.gz"
  sha256 "2f72ef8e9076e8e35c351083f0c3003d577a89246a6b7bafbee973a34714267f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4c1f8714107e823f746fb49ad1d4c5f9cbeb84586f1aa7c6004a5aa4598d1bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac12e3cc868488e5c5fb33dd9f6584547f2cc81a2101823e7c1ec7ee990a494f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b2267255a11ed9c3b43f6733b46f2b39f354397eccb7d0ed16e84a0e2cb4dba"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ffa42fea33efaddf14b1ba6c8557f3340bb4222241d9c6bb5d8e4c1e9cf3f79"
    sha256 cellar: :any,                 arm64_linux:   "a49f2c43b7f74f07be323719a48be551003d94a592046ea53582215ec985369f"
    sha256 cellar: :any,                 x86_64_linux:  "01b193e0c56f52f614ace816c68cbfaddf9052b073fbea51090acfaba40cd848"
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
