class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "dddc4b80ce9e21fe8ac585cf9693e4b3b092986fb260303ad2437330648e2af5"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/kevinburke/go-bindata.git", branch: "master"

  bottle do
    manifest_sha256 "f395774352b1fb86f3950d3fb7207ed9a755ff32f7c43182951319a724fc30f3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "058b6fa15d814718fb8f34f26bdeb064a34582f6e8ebce6d7235c222ebf89137"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "058b6fa15d814718fb8f34f26bdeb064a34582f6e8ebce6d7235c222ebf89137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "058b6fa15d814718fb8f34f26bdeb064a34582f6e8ebce6d7235c222ebf89137"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6699ca13ea8abd323bd498ce2968eac081b7b36caebf15614684c4396e3662af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d7e818362a4834eb167a5d3f243ee8b964a8d01e997bfaae0e12c415aa62f599"
  end

  depends_on "go"

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    File.delete(testpath/"data")
    assert_path_exists testpath/"data.go"

    (testpath/"testbindata.go").write <<~GO
      package main

      func main() {
        println("data:", string(MustAsset("data")))
      }
    GO

    assert_equal "data: hello world", shell_output("go run data.go testbindata.go 2>&1").chomp

    assert_match version.to_s, shell_output("#{bin}/go-bindata --version")
  end
end
