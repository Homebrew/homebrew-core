class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.11.tar.gz"
  sha256 "a9c31cb023bba0f7c751ad9d280723307235c895eb9f6f24fe17495d1af21500"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4c4680554644e0832a23551ef612085ec6db4c8323d6e51f51d57f7e4a45af6"
    sha256 cellar: :any_skip_relocation, big_sur:       "6180f46a4470cf6124fae44378b9c7198cf65fa7e76403862883176c4f2b808e"
    sha256 cellar: :any_skip_relocation, catalina:      "d104154f509a89fd317db2b3b0791fe6d27f6c99b207aae1f29b21abadc65726"
    sha256 cellar: :any_skip_relocation, mojave:        "bcd1962a85584f900d30984d0a0d13198aee05aaa5582f53fd18d86324d48f59"
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
