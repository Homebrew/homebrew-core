class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "9591eac7b2c1e7ef520cfb9c0e43ecf20f2267f2c5f229d59459016c01d05b92"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e90f08b8fd14f5ca169727a8f089f5c9eb6c6fff2b8296ae83f66e6701b94627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e90f08b8fd14f5ca169727a8f089f5c9eb6c6fff2b8296ae83f66e6701b94627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e90f08b8fd14f5ca169727a8f089f5c9eb6c6fff2b8296ae83f66e6701b94627"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f1fb565e6ba889a2405238d1a5618b36abcf1343013d834e61e59fc2309412d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36889f87a89a448b2ea8115135e9e06d9d23bc208fd9049e1437980adf8cef73"
    sha256 cellar: :any,                 x86_64_linux:  "da7cf048144d8a12ca5ff02cf90dc4500493f0de5726b00179e70c9d89fc5c12"
  end

  depends_on "go"

  def install
    ldflags = "-X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
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
    (testpath/"hello/go.mod").write <<~MOD
      module example.com/hello
      go 1.22
    MOD
    (testpath/"hello/main.go").write <<~GO
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    GO

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end
