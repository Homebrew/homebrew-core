class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://editorconfig-checker.github.io/"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "0b84c5090d3f48db1bdfab454b7cde79adb26015d1a2731bba59bc1a636276bb"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "096881de3cd292015d02a4d671ec045e51ac1c2247c71e7c4ef758e9cfbe4d73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "096881de3cd292015d02a4d671ec045e51ac1c2247c71e7c4ef758e9cfbe4d73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "096881de3cd292015d02a4d671ec045e51ac1c2247c71e7c4ef758e9cfbe4d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4bc2fd4433323399b07107ab722d507a0c8d939599db5f149fb3097ae2182693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "89d03d96a4481b358d9c72ba7b764ccbb5f5ac650cd589b7d1802834dd0c47a1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/".editorconfig").write <<~EOS
      [version.txt]
      charset = utf-8
    EOS
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
