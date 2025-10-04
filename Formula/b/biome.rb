class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.2.5.tar.gz"
  sha256 "233885e012f40946928ba8be14af202a8bf152da8adb812743814abc6978e47d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c43ce15c95216c3a50ea9cd615e16e54796df105a07fc27e44a8679699622a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0c52105a220d26b3848bcb1fb99b37e60d24d51e09c95da7646a659dfc6aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dad1548c74e3b39b91fe91706a0f2de98833823ce290165bd326b44da225a0c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8181932f0a391b45c40c7d3d3f2da4f9a7be0a5308463697b5331f523cf39dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a1d53ee6470373075a8a33d2c2295a1f9d1739785ff7b149857874cb383b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edad59676bd6bc6c12a541327b54114fe0fa428fa563c2f676e9be9633711db4"
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
