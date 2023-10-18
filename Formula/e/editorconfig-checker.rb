class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.7.2.tar.gz"
  sha256 "0c0e1105e2adb2c265b188cb66af40fdc86ed99656ede92ef8e92ca5aa8eb198"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1433c6eebdaad1a39a633754bd1cd0994d894a07f1aab9ca5ccffad677e10ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1433c6eebdaad1a39a633754bd1cd0994d894a07f1aab9ca5ccffad677e10ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1433c6eebdaad1a39a633754bd1cd0994d894a07f1aab9ca5ccffad677e10ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "544cab384cb2d3f19f779745cc4e7b4d186bb057049c08ad811e9e297bbfb3fb"
    sha256 cellar: :any_skip_relocation, ventura:        "544cab384cb2d3f19f779745cc4e7b4d186bb057049c08ad811e9e297bbfb3fb"
    sha256 cellar: :any_skip_relocation, monterey:       "544cab384cb2d3f19f779745cc4e7b4d186bb057049c08ad811e9e297bbfb3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832265af85c7f483bd69439d36acb707319ba41fc01f6f0fc6cb00a70e5a13f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
