class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.9.3.tar.gz"
  sha256 "33bb6d62f6ae497e2a26ee41ba5e36c45bfd01245fc6d85a162fe9507c4d08d0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "347bc74b1ccc557c8903f44b1b901b911c6dfe51b82971aaf1550fd71ac5c58c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57b357fd152a2a42d5e16b9b0c876b372f2caab577ea7fc8b4119e166fdf89bc"
    sha256 cellar: :any_skip_relocation, monterey:       "11419245f3207898b8e6f3db8be13307abfec96cc9b7b64a3df9792fe66be70f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d88f61bf522883df17a8d0dc413f1e5b61310d99f61553d267fadf07c2bfcf5b"
    sha256 cellar: :any_skip_relocation, catalina:       "e7c3fdd8d8657c5767fdfafd44dc8ab6285059ba948f29bf695b9cb4e47f2c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3f786521ab277d1258b3ba9b385d9f89cfd4e9e154bccf4e93271d96c34a1db"
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
