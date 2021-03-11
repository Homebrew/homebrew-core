class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.1.1.tar.gz"
  sha256 "ea221438d830057d8bc0f7bbf667508695b4827d5a65ec634111ca5952e6cd5c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5bcea30433a93afeef620532b03d9c0d19e4bb864ee8be5e2a132615911f0c77"
    sha256 cellar: :any_skip_relocation, big_sur:       "85b2788203df32191b839d607d908e43a250d7cd687ad11705afc76f80e0c0d7"
    sha256 cellar: :any_skip_relocation, catalina:      "b69839b084e95f9339b776d979ebffc1382d93917aeabc6c1e1880fb6a9056c7"
    sha256 cellar: :any_skip_relocation, mojave:        "b254aafd541d63d411ec6a034cf88c926b5354cf59bbc37fbaf6eb051fe3a14e"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
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
