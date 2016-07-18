class Gpm < Formula
  desc "Barebones dependency manager for Go"
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.4.0.tar.gz"
  sha256 "2e213abbb1a12ecb895c3f02b74077d3440b7ae3221b4b524659c2ea9065b02a"

  bottle do
    cellar :any_skip_relocation
    sha256 "baef6fd02013c452c8d74ac109de4191823ebc4fb957e184ffd620b4d71b87d4" => :el_capitan
    sha256 "8694759b92b7a01d234ab3369391dcd65fb5558a15d678d5c73cb957eb7573d4" => :yosemite
    sha256 "c4fb2b9cea8b116d1c6145619797bff68cd97c8be9f14dcd9c99cd6bf6e24deb" => :mavericks
    sha256 "0efe4d9fbd5207cff83169a571c7ddb815b434e99b206fc9989e9a309436451f" => :mountain_lion
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
