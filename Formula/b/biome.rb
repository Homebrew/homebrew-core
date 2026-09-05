class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.12.tar.gz"
  sha256 "4cdbaa79c9ade40d31003e37cfb64402c6f36918edecb1cda16bb6111ad1d9ca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c900243dcdb422a28f912722f3c57062ec2239f23a90011d8085e3fa4ee9f17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "453dd12492efaab68bcbf84eabe190ebe77b6ac3df6cd75348ec6f1edf8c60c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e4ac946a8426a8bef05703b11e5b00f6b9abdc7250b5ac67bd7d53ba747443"
    sha256 cellar: :any,                 arm64_linux:   "c9359977c07e80b6294e12875eca8747e67449a1826441c859c75b2129275c39"
    sha256 cellar: :any,                 x86_64_linux:  "3ea5c7527596e57e6b285272123bbae290b53506bb3bd29f6996b91e72afba5f"
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
