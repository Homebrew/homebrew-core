class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "1ee4963e602925237f540ee11c2114dae2ab21bbd816ccecb70f700cfb9813b9"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4640e450be7f6fd4a23d61f1cb3f07a054b816d428cb03c4beaba04b9f6d51b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4640e450be7f6fd4a23d61f1cb3f07a054b816d428cb03c4beaba04b9f6d51b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4640e450be7f6fd4a23d61f1cb3f07a054b816d428cb03c4beaba04b9f6d51b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ea3a86bc3718a00db3924541534636135dbced36b68b52dbd875ed69420a7d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bddaa7d40252dc0985406e8039edb5794a81da869b5ba3481e7e31c7b345677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bb5af22727f73f5a7f1cf66541c69b19f637cf304594d454f42c60b6a996e70"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    # upstream bug report on powershell completion support, https://github.com/nao1215/gup/issues/233
    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish])

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
