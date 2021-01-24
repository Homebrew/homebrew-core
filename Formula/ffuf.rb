class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.2.1.tar.gz"
  sha256 "ff474b21e192005a2df0f09f942b0370bdcb45d64ee35bd8782eb44a5c636e96"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d73f1bec7bce7dda456715a9f0e72dbfb3a320adcae927947ee86fc2b97eaa8" => :big_sur
    sha256 "c34f392d06f10f6b8ed06460e849d3cbebdbd579a684424f66803ec8d168d9b7" => :arm64_big_sur
    sha256 "130a3fd2a4df3d28a6211566f312e18ca50dec665d7d47477f60bb3808d439fb" => :catalina
    sha256 "8040d1fd3ef12a29855b0e3a35dabe91212feec555466b15e879506522ddca6f" => :mojave
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
