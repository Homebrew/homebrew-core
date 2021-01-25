class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.2.1.tar.gz"
  sha256 "ff474b21e192005a2df0f09f942b0370bdcb45d64ee35bd8782eb44a5c636e96"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc742bf45e81e33b6729e7c8feb93e80c0d53fd9945d781d7011f026326ba084" => :big_sur
    sha256 "aa0eb6fbc38d98317bf5bae7ff15578d947fd08a94bcbc4ae46abc2824329ca3" => :arm64_big_sur
    sha256 "97de30d099d5ad9f26d8e56c7c8aed529fa12954b80fac9efdab42d7e2684c6f" => :catalina
    sha256 "59efb524bd1557046e971712c83fe23ad970ae36d64f6b07d21c702183441192" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
