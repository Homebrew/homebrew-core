class Gpm < Formula
  desc "Barebones dependency manager for Go"
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.4.0.tar.gz"
  sha256 "2e213abbb1a12ecb895c3f02b74077d3440b7ae3221b4b524659c2ea9065b02a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a154116f76d46e8937df820ff8f36b2600ffa80f32bf0b37fca2204318306efe" => :el_capitan
    sha256 "953434734f58fedf6224bc78310842ea7b49570274eee4d9f7365d2dc0876014" => :yosemite
    sha256 "e3e4f39ffb4e13bdc4d3dcb96a44a9862f983213e21130969e8b4aafa7b0c9dd" => :mavericks
  end

  depends_on "go"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["GOPATH"] = testpath
    (testpath/"Godeps").write("github.com/pote/gpm-testing-package v6.1")
    system bin/"gpm", "install"
    (testpath/"go_code.go").write <<-EOS.undent
      package main
      import ("fmt"; "github.com/pote/gpm-testing-package")
      func main() { fmt.Print(gpm_testing_package.Version()) }
    EOS
    assert_equal "v6.1", shell_output("go run go_code.go")
  end
end
