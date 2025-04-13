class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "c894001609443aa970cf19744e1cfe968eddc9bdb42b5fa29944842a5309c02b"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6bc8620eb569a95d635d373a9e4aba5a5701cb3e65f01be861c487113e8320c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6470f69cfe07e82ff68c810ae85a2f38cac94879cedd617ebefdc3609a875e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a3b7a7b6d1e9ab19982340dc4b6057f055168dd0f5366ffa6acdd3a6fafd2ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a605164b15e304d64a64330e9efe19f8310a83e1820bceebf011de1a0a7eccb"
    sha256 cellar: :any_skip_relocation, ventura:       "a2f0f05fe960b81a9a9c94045714607f094f3b212a8455fa7c707075c62906c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c738afe099cb763de8c2c7ce03c6286e84b5765fbf99b4debc0e24bc7b7fc1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "047e7b158e3854c321f6df0e440a8fc3173ecf583293d716c131c22ecc5e03d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 2)
  end
end
