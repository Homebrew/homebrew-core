class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.10.tar.gz"
  sha256 "7bb74776e3db235f7c15f2138758798f28db838eb1dfaa46cf8eaa2743538c29"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc9327a327e457fc3eb7e8732d7a6ab63f695d07da28d7227c96b71c1936ecb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff35f16e7a6a74cfa556b3d31f06484024a63e1edbe0fec4dd707a7d6576069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae28dc72317922c20199509c85d4fa3349345cc1f270537441286873d34a4403"
    sha256 cellar: :any_skip_relocation, sonoma:        "445ff48d93b1943afb9f773f076687218277b3fc5217fcb7d31063ebd68e7d76"
    sha256 cellar: :any,                 arm64_linux:   "3a0c62712796d9f78e43fc1bd579c7d283573306a169b2be033d7d0568810742"
    sha256 cellar: :any,                 x86_64_linux:  "e26510bb1253255dfe71213a58a8366b467b5e285d9829f8f59b8ab9d8168e86"
  end

  depends_on "rust" => :build

  def install
    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
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
