class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "a12ebca72e43e7061ffe4ef910e572b95edd7778a543d6bf85f6355bd290300e"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4e3f6d0c90d3cca8ed7b6405d525fe5ddda8f63f7c61dec24c1deb9fddcf9bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d833d4f2134eb94e5062bf1286da9b53e8054e32710f8b6677de914b92b83e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b11fba2474e6e24a697467b232c5cebb6721f71892996162fa138e79a0188b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d0d5b81bb0fe59cf6dbea23813ef6f069d25cec0138a8cb4710657dbf89b57c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d779b7d3f5968eef74405f45d0fa213246baff6167d5b30332ae58c0e40ae433"
    sha256 cellar: :any_skip_relocation, ventura:       "938b8bfa969c79fc6112292dcd90ee25d6ea4b4fe3472aeb33718ca92ec6d9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1dbbf7eef0126d88c484d629eb06569f318808e133120cf98478c31befdc8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d40920e6c3486ac5d0e52355bd7ad9709439be11676e791e6b5eb31881dca4e"
  end

  conflicts_with "go-jsonnet", because: "both install binaries with the same name"

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
  end

  test do
    (testpath/"example.jsonnet").write <<~JSONNET
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    JSONNET

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
