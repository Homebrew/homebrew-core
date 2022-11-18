class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.10.1.tar.gz"
  sha256 "31ad2f8fb817dab13055735ac909c7058f01d5c0c270fd7df5c6dc9050233bdc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03e288acd744c5d934e7bff58b4d21f77ff93bb82cd8ff11bb7d91f4dad968e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1112255a1b2f3334d97c113329e67b62e0ee49eb6fd94f13d70dd21b98e2d592"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62bea0cb2b15a61aec22d85648715921da82e052023e7cf65511a29e80050737"
    sha256 cellar: :any_skip_relocation, ventura:        "a8f32b0eb9f256ba17cced2e5575752a81227155fc6691823ea522587f5c880e"
    sha256 cellar: :any_skip_relocation, monterey:       "76723be3c04034e3ca66d268d49cf388d13ae2f95f20c27a33ff354019e87077"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c8b7fcd525e41dd631dda1cdd0b0df694f7b99f9ec625963f17634ee2cbcfda"
    sha256 cellar: :any_skip_relocation, catalina:       "6c31cc33f8a7a0c76fd285cf24208d784c13006842c6de4690fca9fb92486595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8844c45891a23ecd584f67d0d988e608544958e74b0ed1a4461d940316a03a2b"
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
