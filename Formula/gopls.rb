class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.7.5.tar.gz"
  sha256 "b5f5881dc6b73aed1023634f6f524bde0301bff22d183d97682adcb0ce94c575"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "228c9f719fd6db438deb9297f45577bafac16528cee75ce8f6563080ab3e04ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1bef5f73ef27ddcfcb3c93390f13d4695d51a500f8581cb6f8580da374e809"
    sha256 cellar: :any_skip_relocation, monterey:       "29cda7bf7e42292ed68f7ea8d9108c7acebbf0a4c620dce55d4422c934f0fe86"
    sha256 cellar: :any_skip_relocation, big_sur:        "936cb51aaed27c7df329ae8022d1ca5034c1bcb1500ebff0994055e457903f83"
    sha256 cellar: :any_skip_relocation, catalina:       "1cbef53b7967ca07e4a2fa75f22ba87d26412a9ee002bba34d606d7f40471273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad388a8778d9e2dcf94017c92d83210493eef041809ea183d83cfad7a86008c4"
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
