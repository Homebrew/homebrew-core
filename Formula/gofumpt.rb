class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.2.0.tar.gz"
  sha256 "17b7a921ae385a91aed8d8c09485736f5a53cda2decc085a390fc7aa270fdef0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66c12869f4c92916a246102d9652dbba3d269e85eb68d38e2082dc53a2eca7d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66c12869f4c92916a246102d9652dbba3d269e85eb68d38e2082dc53a2eca7d1"
    sha256 cellar: :any_skip_relocation, monterey:       "34cdcb6a5ebf9f0f8131f2df3ffbf576ebaaa90697eed45b6610e9a0348029a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "34cdcb6a5ebf9f0f8131f2df3ffbf576ebaaa90697eed45b6610e9a0348029a0"
    sha256 cellar: :any_skip_relocation, catalina:       "34cdcb6a5ebf9f0f8131f2df3ffbf576ebaaa90697eed45b6610e9a0348029a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16b7ceb1cdb65f8d82ae4de1ad7ad10c3e81fc2447b536cb3c10a1a14db21c9"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gofumpt --version")

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
