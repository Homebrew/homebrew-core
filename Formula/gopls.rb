class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.4.tar.gz"
  sha256 "4e90f083d3659a0640538e3e4b047b8474de5c9a69525e535b840281734fc3a5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4b69615dc1f6176234a0fec7f18eb05780974cda2dfbc3bcd7968bb24a6f7956" => :big_sur
    sha256 "282db03026f37bd9524819b1b29669867c5f37291530068bb89a3329d39e7af4" => :arm64_big_sur
    sha256 "1434bd31979a93b1a0a411fefe49941b2677e266c625e75c9ad1f3bf46632fbe" => :catalina
    sha256 "817f06f87c58fc9b04f0e33e2ed77b7100f76e6d795913940f7a749138bace1e" => :mojave
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
