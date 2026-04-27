class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.13.tar.gz"
  sha256 "beada30b666697551a8994182da3f9c2a5096c728f48f9e00e12cdd97c74deec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "434866b073a6fd84f1b2a0d26b9166a551edb5d52ed49ebc905192839f36bc19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f00c3dddbb8cc42035815e558556304836ed96a50f576e86e4de433d04dcf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f60b8916a0b9dc714b3670df5524c389399cf1b372857f41a21088d02c1328"
    sha256 cellar: :any_skip_relocation, sonoma:        "d863e3de3b9e032c1f2fbecd293a4a5ad93f6d9367ecfa4fe0c53146151353ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c63fec603cff3629c9534cb169030f95da2fb3353bcc223a0f5acfda9a0052e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3ebc3b18631addb75a52bc26fd1aa8b39c5477b351cc2f524162fd9afeeb75f"
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
