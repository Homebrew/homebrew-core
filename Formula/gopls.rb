class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.6.tar.gz"
  sha256 "eb212db3c41fa1b234b239892853329b0abf71e6c683da1d84f6be330127bff6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "979f6f5b5bbae00ec9bcc5633740049a11377d3dfa330d47dfb2feae95ee71fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1eee49bac5be73717a980c5eaed7012e9725db26e592185997460b89f8a74e2"
    sha256 cellar: :any_skip_relocation, catalina:      "833745810ea15b2555c5eba60b959fc7d10c6c6a54a3936fbea3387b8a20b39f"
    sha256 cellar: :any_skip_relocation, mojave:        "2b8cddff3120787cbbd9f500488b62dca762aed096c26861a5749f621b76fc17"
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
