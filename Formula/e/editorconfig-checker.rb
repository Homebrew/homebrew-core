class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "8d5e350be7be6a1e08811359f5e0e3dc922113a19ad26a3813d82607c303022e"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cba4db2f95175ed8c49cbf99b797723659eb0da6f1b8b8e1e5a861c67fdc7770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cba4db2f95175ed8c49cbf99b797723659eb0da6f1b8b8e1e5a861c67fdc7770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba4db2f95175ed8c49cbf99b797723659eb0da6f1b8b8e1e5a861c67fdc7770"
    sha256 cellar: :any_skip_relocation, sonoma:        "82984679b4a285b6b39089043c31f58165ba7beeca3cfe43ebc4d2fa81ff57fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb669fd1d325571d86f5004f4d59cced1148eec78e03701529d619527381fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b71d8872346dce7032fb5ad95354a56390b2711d94c5f7e64dbb1458278b96b"
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
