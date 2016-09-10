require "language/go"

class Gost < Formula
  desc "Simple command-line utility for easily creating Gists for Github."
  homepage "https://github.com/wilhelm-murdoch/gost"
  url "https://github.com/wilhelm-murdoch/gost/archive/1.2.0.tar.gz"
  sha256 "2dfe960f13a4dc6abb1148a28083d474f8caf63d5cf756558bf94772266f8512"

  bottle do
    cellar :any_skip_relocation
    sha256 "42a60235f9f31d12b59d33867b4f74ac4e4fa979fd92f7066bd5720da2eb607b" => :el_capitan
    sha256 "7acb5fcbd1230614a630cb4c0fefaef4a40b66dba633e067a641c17a4d444db2" => :yosemite
    sha256 "7cc1cf98d45f0cfd43e0d822d60430670e58dbd40f221033b2a446f0f03bb681" => :mavericks
  end

  depends_on "go" => :build

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
        :revision => "8434495902bd0900797016affe4ca35c55babb3f"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "35ec611a141ee705590b9eb64d673f9e6dfeb1ac"
  end

  go_resource "github.com/atotto/clipboard" do
    url "https://github.com/atotto/clipboard.git",
        :revision => "bb272b845f1112e10117e3e45ce39f690c0001ad"
  end

  go_resource "github.com/docopt/docopt.go" do
    url "https://github.com/docopt/docopt.go.git",
        :revision => "784ddc588536785e7299f7272f39101f7faccc3f"
  end

  go_resource "github.com/google/go-github" do
    url "https://github.com/google/go-github.git",
        :revision => "842c551fdeae14c97c04ef490f601ae4d849a00c"
  end

  go_resource "github.com/google/go-querystring" do
    url "https://github.com/google/go-querystring.git",
        :revision => "9235644dd9e52eeae6fa48efd539fdc351a0af53"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gost"
    bin.install "gost"
  end

  test do
    (testpath/"test.txt").write "42"
    system bin/"gost", "--file=test.txt"
  end
end
