class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "26a7c8dce1f153d250e7d36665cf7fab3776aee83248f94be4ebbad23fcaddc4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ab381b52eee934d5a02f3595113849d18b9e486952d01fc36822dba681ff293"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ab381b52eee934d5a02f3595113849d18b9e486952d01fc36822dba681ff293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab381b52eee934d5a02f3595113849d18b9e486952d01fc36822dba681ff293"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bbf4cd6b9b4d2172b60499a7aae7da01fe63c2f3c9ecc26e69eea57eac5db8b"
    sha256 cellar: :any_skip_relocation, ventura:        "3bbf4cd6b9b4d2172b60499a7aae7da01fe63c2f3c9ecc26e69eea57eac5db8b"
    sha256 cellar: :any_skip_relocation, monterey:       "3bbf4cd6b9b4d2172b60499a7aae7da01fe63c2f3c9ecc26e69eea57eac5db8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f462e72be27e9a0d1d87d60482b52728fe459882566040c47e44b3d498b5054a"
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
