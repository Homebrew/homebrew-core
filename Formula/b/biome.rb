class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.8.0.tar.gz"
  sha256 "fae441b335403076d6bb00f960ad25c3539bc2fe08d67e8de25d4feba7173e42"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "064c0165b54a5b4e0e435b234586dcbfac02214fa020ee7c7e3d3a87aecdcf0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33fde567c73fe77bac8522f122e73a7fe29b339c9fe4b5eb7bfcafc890698c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be080945c1d1d12f5537aca5184cb3442f02baaf0bb9a44dedd5ab9da0fc884a"
    sha256 cellar: :any_skip_relocation, sonoma:         "47df8a8d056d3d7ebaa897c9cb9b0b3a45b93abea8ab72585dd5ea82904f4e93"
    sha256 cellar: :any_skip_relocation, ventura:        "406fbdb43d39dbb2390880172d6c993930964bd99810a059f24e7f440cd594c3"
    sha256 cellar: :any_skip_relocation, monterey:       "18f16d9feee476fefeda3347b94d549927c1a344af0a625845ab8471bda1334d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f07c00a05197b13f1f637da78fe6b7703a972450db969640810104921e0b48"
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
