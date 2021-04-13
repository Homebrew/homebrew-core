class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.10.tar.gz"
  sha256 "daccfbc2636085c01adaf5deff0961f7b5855f84e80021b50009a54129c6ea65"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9f71b730b2a49d5b1248e9695d07410e980bb2ac539336b47a2eafab118ae88"
    sha256 cellar: :any_skip_relocation, big_sur:       "29c406b7357ab2082b95110ee9d96f3ce322293ccd248ed611a13fadc56aa88f"
    sha256 cellar: :any_skip_relocation, catalina:      "3f5a24b417b7a52ebe3f9b6095d5e2414636c28c523ba42cf0b1f49f7efe4a3c"
    sha256 cellar: :any_skip_relocation, mojave:        "fc452dcf3a2ba8068ac6e301e90f25addfc1a3022d0621bbf0b8fec8ffab8433"
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
