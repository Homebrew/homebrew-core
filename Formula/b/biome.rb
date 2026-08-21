class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.9.tar.gz"
  sha256 "21b140f618e7d78dbcbaad036aa036c4ca451bfffedf61aa5887f0d72d31e4c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3395e6d5f18f24b81f6090d8c14d499baf8ee14ae5abf7c1f64b7e5ad6c02f65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b221d26ecb2f8d44478718f52da77b01e76e72190e534d02305dda556a2d86a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5c2b0893797e0db58285f756d73ac8b69993f13fdd242ed730696b55e109004"
    sha256 cellar: :any_skip_relocation, sonoma:        "44dfa2c5de2bc9ae23bdaec9fe32724aec26cd32d487ec8677544aa353748116"
    sha256 cellar: :any,                 arm64_linux:   "592e6d3b279bcb3f572cf20f50d04e2866caa72e22c5955eb00ff4c728b4d1da"
    sha256 cellar: :any,                 x86_64_linux:  "99fb4671a4a758506e366f3ae817da5c1357f96b33e70a4cb2477f0616b98a04"
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
