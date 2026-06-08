class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "df08c7aa8eb33c147ba38b628f53aff7baf3877d44c577d8964d9899e8052c81"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "765f27ee4ade870cb1aa5cbe3d4da0b01252e4fd786010a5bf7495900a5ef86a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "765f27ee4ade870cb1aa5cbe3d4da0b01252e4fd786010a5bf7495900a5ef86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "765f27ee4ade870cb1aa5cbe3d4da0b01252e4fd786010a5bf7495900a5ef86a"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d13f384d62b3503db4c82297742621fb5e5c23856296c91b96d218de40607e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2e3b5cbc07b15e2345043451de37d69af31b118d1b12c4f9d11f84cd8f30ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163c4067dc70610dd98b85a6cba36cefffe14b3b5a73c9cc88ad6d2c611264ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
