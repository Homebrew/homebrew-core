class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.13.0.tar.gz"
  sha256 "84253d68187a1f7e11c8d224dc4fc41d38e9d250b67d9103458e4c8806ae8c97"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f96208e0fc51d178a34499e38f4a3f41dbf8e26f236ae496ba8a109d51810d37"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f96208e0fc51d178a34499e38f4a3f41dbf8e26f236ae496ba8a109d51810d37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f96208e0fc51d178a34499e38f4a3f41dbf8e26f236ae496ba8a109d51810d37"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fadf155a3404f000af9bc966389269abee4cca16da4665bf0a728b40f8831cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "183e9ede3abbef545a20c31b7ceb54f19eca66af833186b87e859c4b41bdd43a"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    ENV["GOROOT"] = formula_opt_libexec("go")

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_path_exists testpath/"osshim"
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
