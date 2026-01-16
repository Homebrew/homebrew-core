class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "c20d5b524442437f17d746040cc27d496a5c9fa180d31f07a643c33984053f2a"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95d56228252c1a255ab939ad4c330632dfef0b8ae0fdcde6bbb87da56755f7fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ebb8387070352405fec67061993e5a03e46371442550131ba11598a3eb4e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db31be41d72711b0caf46cdef8b5a9e0f6ecec03ad10e97f89c9e875f09a609"
    sha256 cellar: :any_skip_relocation, sonoma:        "15f6bdb844e2f38b980a8f869342f50a9bee304efdc889cfa03b4b70ab880489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf03dde80422794a12003efb4b0ff3854b7dd7ad56c397bf7d51fdbd4180c901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1a54c12a6bad65c99323ff11e419ae83a2259189ff27d990e5eeeaf5790a3b"
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
