class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "72e1dddb4fb241119c77c6f53e3d6f9baace955d43e729d9b5aacb4ce4f54e4c"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d02bd86731a696968644c16a4426f1dc7fff818adac6bb829da9331a6d29724a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d02bd86731a696968644c16a4426f1dc7fff818adac6bb829da9331a6d29724a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d02bd86731a696968644c16a4426f1dc7fff818adac6bb829da9331a6d29724a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e827f9ea06b10123f7a46b76550e37b2798fe68315a583dc4f96133ee651233"
    sha256 cellar: :any,                 x86_64_linux:      "df581b9b9337d419b43e1aceb2e665d827cd19dc4e6d8b63c381fe0e7167464a"
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
