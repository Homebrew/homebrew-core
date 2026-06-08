class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f24d4ddb61e1fc34d81d5c384b8bcc1af249d31aa800a22cb7e30c1b7fd6b87a"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d457bcfd5c1ee1474d1762cfbf8ea8fb9930185fea005bdba4b7d2df8fdfeff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d457bcfd5c1ee1474d1762cfbf8ea8fb9930185fea005bdba4b7d2df8fdfeff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d457bcfd5c1ee1474d1762cfbf8ea8fb9930185fea005bdba4b7d2df8fdfeff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ba859ef3332bd52cae6296f8cb5b70722c5b45567f1ca34a0e341be7205f2bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45055b8df7bb6cd25b54753c7ddf85c312a83d3eb198df989ae2fa75485566d0"
    sha256 cellar: :any,                 x86_64_linux:  "bbb9f0acdd26d4ea87f81f463ef91e73cc4a23f55b84bc56b5df29e46ff551f0"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra)

    ENV["MANPATH"] = man1.mkpath
    system bin/"gup", "man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gup version")

    ENV["GOBIN"] = testpath/"bin"
    (testpath/"bin").mkpath

    (testpath/"hello").mkpath
    (testpath/"hello/go.mod").write <<~EOS
      module example.com/hello
      go 1.22
    EOS
    (testpath/"hello/main.go").write <<~EOS
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    EOS

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end
