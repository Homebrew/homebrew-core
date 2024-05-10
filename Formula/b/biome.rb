class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.7.3.tar.gz"
  sha256 "58202d09603f2285ef8454b328218139640b8aeb5f32d7824535a20c5dd4f765"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d9e5d0009d414035197a2ec1660d168faf5f070e16aa0a260aade967b26e754"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f49df49e2b502d9849de20ccd998a7c967e859c5375244ea23bbf48fb31701f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee25e0f8c77be4ba9377cddfb4d169c4a261c4e6b7c04e178409159ae4213011"
    sha256 cellar: :any_skip_relocation, sonoma:         "13c37504dc6320e5f46465117e619a1144ac0d6ad4f108fd669a6e61816404ac"
    sha256 cellar: :any_skip_relocation, ventura:        "c3d30e2f0b0a0b6f4129db08a685750bd6e5f02f965632a59cc0156864f3f04f"
    sha256 cellar: :any_skip_relocation, monterey:       "5455dd926bc61f7bb37a4c5f0e6d9651c6678c12e3d6baf2b0ae83ae92f2551d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0680d59b874eb370cba28c847d5e3ac17c78b57461ae86ccfe4053987776b948"
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
