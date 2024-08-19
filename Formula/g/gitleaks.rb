class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.18.4.tar.gz"
  sha256 "68829e1dcb6bf412f04354070187947896af78c1f0fbe7f697eda18417f214ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6c63682bce671400e51943b8df178814c064774d046d595d36fddea5a00c671"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6184272d9d0520d2a51d0284a26d314f286bd6cc263cb4db6eeaf08dd91a41e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68d647a6d839e1f78a16ec1a4347d1fc5622a40e21775cddfa20367ae2807a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f23cc3f261b57ce33d0acf93c46212020c26e8a3dbd0b2768c50cbdd08761576"
    sha256 cellar: :any_skip_relocation, ventura:        "81b2b2fe7c17ee25c5ce5d335ea68fbfd1bf4837e1ce975b0024b20b781ae187"
    sha256 cellar: :any_skip_relocation, monterey:       "b64fb731e34902eff192e0b8b49866d6c4a6c93b8e22424070c4fd57b0140ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a5b5843c46addd9abe3fba2b4c45930a8ad748b193de39db3cb2c3da0830d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
