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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962af9ccf9ef64bf6e5dd5557893e1cbd8bc1b1e7293317c52d5815811538047"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd32a1469a42b784b60b74bac189fb377c53a6741130c5597e39ae3703557ee7"
    sha256 cellar: :any_skip_relocation, monterey:       "db61f1ae31143b7a95fd0f6efd8d95d8c85b0b5e5c81075572480e31ab1e321e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3276699d6b016bd9f5e1e66e52c3bffeb4906dc35d42402efa00015cc66b5ce"
    sha256 cellar: :any_skip_relocation, catalina:       "99e4336d7606ca18fb423768e771d14dd74ae7229856926cbdde029d7a22884b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583a00901119bd720df4c0be74c6a52431d675b57de73354bc745ea933c4f5f2"
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
