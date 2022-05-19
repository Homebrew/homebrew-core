class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.8.4.tar.gz"
  sha256 "815060abeb22755352414ef62ffb265b2f0f9d38786c164595f85c9c25c8a7cb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65bf8063b67a017625da0175a83fb8d44dd4c78687a53ac33b71587f4602858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fbc416321ca666d572fca4e73985f68a2fa46e4a9ec69e2ddf0d83e98f21aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "ad01b0570d2da32a39004097021898df929898d37c245b037703db49a4063c48"
    sha256 cellar: :any_skip_relocation, big_sur:        "58e9c04f4e1832519fdbd7bd9d31196ed4d38c4ce0991812c5c18c909066659e"
    sha256 cellar: :any_skip_relocation, catalina:       "521bdc13d461df52a2d006e755c64dc40cf63a4f4246464ed3ba86e90c93fcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b68e8ef9e3c52d48a5951fbff7c8d7c454c946e061077bb6da43d8b1f04ad527"
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

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
