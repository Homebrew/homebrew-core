class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "aea6e0a172296b50e3671a9b753aeb2eb7080a3103575cdf5e4d1aeccfe14ede"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5715a8ccc015d8152d67195f34d15a4095b4f9468ae466553935a3d2c759a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5715a8ccc015d8152d67195f34d15a4095b4f9468ae466553935a3d2c759a47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5715a8ccc015d8152d67195f34d15a4095b4f9468ae466553935a3d2c759a47"
    sha256 cellar: :any_skip_relocation, sonoma:        "824f09b76e9b67cf156efb2921ee6b41bb5797dad8f1b21832eedf337ed84b6a"
    sha256 cellar: :any_skip_relocation, ventura:       "824f09b76e9b67cf156efb2921ee6b41bb5797dad8f1b21832eedf337ed84b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c375abc7794717bb46c545ddef748afa6fc7ce49ce28de8148219a4d855eeba"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
