class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "f3538d9db5df0d0325f3eaab7e3d465a6ec9ad6067051863ac52241f070824a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63bb566ba8ddb8f8e0f8777fffd38e960e7621101f5025edd6403cd016a6d531"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63bb566ba8ddb8f8e0f8777fffd38e960e7621101f5025edd6403cd016a6d531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63bb566ba8ddb8f8e0f8777fffd38e960e7621101f5025edd6403cd016a6d531"
    sha256 cellar: :any_skip_relocation, sonoma:         "082f7739235465d496f7a7ee86c6103aa06c12ee9763f2f2cba90b313ed69119"
    sha256 cellar: :any_skip_relocation, ventura:        "082f7739235465d496f7a7ee86c6103aa06c12ee9763f2f2cba90b313ed69119"
    sha256 cellar: :any_skip_relocation, monterey:       "082f7739235465d496f7a7ee86c6103aa06c12ee9763f2f2cba90b313ed69119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "138dd8bbaab80928ea969babd37082b96d10906fac351880391e844a2f5b58eb"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
