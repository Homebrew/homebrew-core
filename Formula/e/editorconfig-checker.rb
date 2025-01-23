class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "b01e8d2a07c889e20d3aa9ac2d783484b7a1366bee8f3332cd222c23f6610d4d"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b64eb8065d014570949c05b5e489a23b0a756d2445c1f45606b57ce86f9d4802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b64eb8065d014570949c05b5e489a23b0a756d2445c1f45606b57ce86f9d4802"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b64eb8065d014570949c05b5e489a23b0a756d2445c1f45606b57ce86f9d4802"
    sha256 cellar: :any_skip_relocation, sonoma:        "99164d5d8386792a2730f78942e73c7ab7042f6c84ea308b6c67bcf36cdd0f1a"
    sha256 cellar: :any_skip_relocation, ventura:       "99164d5d8386792a2730f78942e73c7ab7042f6c84ea308b6c67bcf36cdd0f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d0d90fc172f2dbb8298b4eab1dd04c0c9362b21cee025670c45305a58e4175"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
