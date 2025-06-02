class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "aea6e0a172296b50e3671a9b753aeb2eb7080a3103575cdf5e4d1aeccfe14ede"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ec2f692cb8fa1413dd70e4adb73a9379c177ad67d83c5edc6223022116420f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ec2f692cb8fa1413dd70e4adb73a9379c177ad67d83c5edc6223022116420f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ec2f692cb8fa1413dd70e4adb73a9379c177ad67d83c5edc6223022116420f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "932cad6102367a29f5092455a7859df9f69251ddc1f82c5af7ae9f37f830835f"
    sha256 cellar: :any_skip_relocation, ventura:       "932cad6102367a29f5092455a7859df9f69251ddc1f82c5af7ae9f37f830835f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202e90501c53fe9f6f324a7175d2087d0113e69d012219acaed1a4dcdac26498"
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
