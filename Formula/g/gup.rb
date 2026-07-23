class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "e01a0c2ac567a61f31fac28b656022a6ba3a63c1226655eecb4f40b92a0c9ca0"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65fb815f7f2512c44a7c9d56fe17219f519b4372627ca0670cd4bd1c85d0a834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65fb815f7f2512c44a7c9d56fe17219f519b4372627ca0670cd4bd1c85d0a834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65fb815f7f2512c44a7c9d56fe17219f519b4372627ca0670cd4bd1c85d0a834"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9cb12ef30c0d4d9c0f46f97c9511fbf8f1abdb55362f25b84e9926c2aa735d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65251903aac664759225fdc0a9f364724052ed0ebfa13931a597ea9445e0a838"
    sha256 cellar: :any,                 x86_64_linux:  "fa940584d0455c94a5c580a5bcaef191e8c1edc6a3ef6dfc43cb4307a6a4556f"
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
