class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3b321e8ca9bd3b2d217bf3a2530d9ffb063a747caf616456fa925d511765b2ae"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdfddd3bc17f51fca9c03c504d345137b454c9275b01538fdb645c50be0d10b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdfddd3bc17f51fca9c03c504d345137b454c9275b01538fdb645c50be0d10b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdfddd3bc17f51fca9c03c504d345137b454c9275b01538fdb645c50be0d10b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1aa94c98f4edb7ad88bb7194f3ad9f135ef908c4edba72ed880ac5b68d1a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cd5cc64177ae49c30deafaec77ec92f9b9bd5acbc591e4e67db2e02696ca9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da487ed6075b10c502fe4ab273e279c5c4efd2b6b41e4d7e1344c58aabd8f444"
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
