class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "64845b14b5974e5a314e056c16404fad08cec1a34ffd7d531b4e032b4cebd996"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3c040994d0e742244ca64ff9480f2bd622178e5efc80495b3f4081eb525006e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3c040994d0e742244ca64ff9480f2bd622178e5efc80495b3f4081eb525006e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3c040994d0e742244ca64ff9480f2bd622178e5efc80495b3f4081eb525006e"
    sha256 cellar: :any_skip_relocation, sonoma:        "44fadf420265faff145e383d2793796b4d4780c02297d3db4842e74af96451ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3075dbf87151110f0bda7dc500f5203fd5b7d0e6997cedd389a5c8959ff3b0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c8ddb72bab46b8e49c700bbf588fff72f6b549ee8df82b486bba951341dec19"
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
