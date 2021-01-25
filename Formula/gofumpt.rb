class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.1.0.tar.gz"
  sha256 "802c92d3df222c9b266d785305107c58a26ea186c4dbb5989b0db97b9bce0367"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "85b2788203df32191b839d607d908e43a250d7cd687ad11705afc76f80e0c0d7" => :big_sur
    sha256 "5bcea30433a93afeef620532b03d9c0d19e4bb864ee8be5e2a132615911f0c77" => :arm64_big_sur
    sha256 "b69839b084e95f9339b776d979ebffc1382d93917aeabc6c1e1880fb6a9056c7" => :catalina
    sha256 "b254aafd541d63d411ec6a034cf88c926b5354cf59bbc37fbaf6eb051fe3a14e" => :mojave
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
