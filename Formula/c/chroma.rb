class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.23.1.tar.gz"
  sha256 "982fa634c6b2f153143ca35e2626335bbca315ede57f64050af16566699aaafb"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1da95b99aa0957f9f91d27470f6f523af5e85a83489265081fb4853c3e0e10a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1da95b99aa0957f9f91d27470f6f523af5e85a83489265081fb4853c3e0e10a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1da95b99aa0957f9f91d27470f6f523af5e85a83489265081fb4853c3e0e10a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b62b7bede674d658a4d4d53029998ff6de919eb782b2053cc529862ce1d4af84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec026fbf748b7e0f9f392e72b56645ac970c27641b0c94b3db82fea072b02c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b2bf8ad75617ece86443d200795d13ba61ebeb5dbb18795bc9269e797b76478"
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
