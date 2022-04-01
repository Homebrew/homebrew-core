class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.8.2.tar.gz"
  sha256 "761aa768e82a958e6f803db39215c995fe0f263df825ed1cbb9f6b2989f0cd00"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7af9c413acc9f4c273363fb6e66be061b0308b888b6ad1d22fc4136373988cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbc6dcaed9660e4b2d11ab60fd825f44d433cf46c16cdda7ee79008e7d87caeb"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9cebfe1ebd5872e78a83ae54737d652909213b0b14c8094e16cd25b16ccd44"
    sha256 cellar: :any_skip_relocation, big_sur:        "590332d9cc98ce1bafee0f2f718a2ee8627a2e6a356d22f560ea509b17302433"
    sha256 cellar: :any_skip_relocation, catalina:       "1980d2a93edb235521f6a42418e156c741bf0029cc2ef7d4a879062ee3f882f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb59a2ff25d13ff2267b018e4c35cd1ff8a4c42dc5907beb76ac6b30d3892ea6"
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
