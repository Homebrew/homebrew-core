class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.3.tar.gz"
  sha256 "fa50bbd02cadf8e45617a51f51379e22a67c9f1cada201cf01cb0750f7bb2a69"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "993e041b4ba12cca38618de40b7ee84b30569a12cec6feaa1b448dad21d4b2a0" => :big_sur
    sha256 "39a87f988618b133217f17887154108d4c49109e06f00f1ac4f9a3184605b001" => :arm64_big_sur
    sha256 "88c819f3f983bdd985b82015ea00941e41e5911e1a5837abe0a75925a275f622" => :catalina
    sha256 "493bfb615a76e0240b83a7522488d56418609c97c3f535e6892cf32636e87273" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.generate", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
