class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d994902b3cb7eeacb23ccb949185dd036a65b9fc316a11a8842f7aa60f5ef4ba"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce9d1a180a706c889da51616f5d0a94b84c685cb4ea69abee95d91985984d684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "802a9c765f76388742f10deb24d0a8ead35ad976993a5709dabb90cf4d373588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "802a9c765f76388742f10deb24d0a8ead35ad976993a5709dabb90cf4d373588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802a9c765f76388742f10deb24d0a8ead35ad976993a5709dabb90cf4d373588"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcdd825b173315f71b186d428d7b4fcdd831ca4d6132af041f26adc63a75b97a"
    sha256 cellar: :any_skip_relocation, ventura:        "dcdd825b173315f71b186d428d7b4fcdd831ca4d6132af041f26adc63a75b97a"
    sha256 cellar: :any_skip_relocation, monterey:       "dcdd825b173315f71b186d428d7b4fcdd831ca4d6132af041f26adc63a75b97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db3d516cdc64e75aed5d8e651cca5e75ff5bc06400fafec9fd11b64379433f8e"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.go").write <<~EOS
      package foo

      func foo() {
        println("bar")

      }
    EOS

    (testpath/"expected.go").write <<~EOS
      package foo

      func foo() {
      	println("bar")
      }
    EOS

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
