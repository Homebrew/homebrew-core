class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "b6d5d14692cad23996da4329bf24d30324af30125dd5261e6d9b0c5bc8b20b28"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3516a75ecfb1277f3dddb84af979be8e13b702376b343be9624d8b059aa7fcc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3516a75ecfb1277f3dddb84af979be8e13b702376b343be9624d8b059aa7fcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3516a75ecfb1277f3dddb84af979be8e13b702376b343be9624d8b059aa7fcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c3516a75ecfb1277f3dddb84af979be8e13b702376b343be9624d8b059aa7fcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2bd53d9631ade4ce6051e7a6bf8011b59d1fe5530f9cec0f8f1c70ca591926ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cf2294efce565123124ba6150fe37039fada73c2ae806c7b010faa9df12e74ab"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gofumpt -version").split.first

    (testpath/"test.go").write <<~GO
      package foo

      func foo() {
        println("bar")

      }
    GO

    (testpath/"expected.go").write <<~GO
      package foo

      func foo() {
      	println("bar")
      }
    GO

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
