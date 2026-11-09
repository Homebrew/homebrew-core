class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "72e1dddb4fb241119c77c6f53e3d6f9baace955d43e729d9b5aacb4ce4f54e4c"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5e78bde7334893d0e1bc82b8410f6359ac96e4ea90f35ace3644d1656dfca47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5e78bde7334893d0e1bc82b8410f6359ac96e4ea90f35ace3644d1656dfca47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5e78bde7334893d0e1bc82b8410f6359ac96e4ea90f35ace3644d1656dfca47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce6d247dbf3f0d18361afb74193f058e5713c77057dbf74c8a6dd8dcedae36b3"
    sha256 cellar: :any,                 x86_64_linux:      "086953eb24d1ed430a788087114b9fa97f533c9a3f26e8ddb8d1e5e87777bf24"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
