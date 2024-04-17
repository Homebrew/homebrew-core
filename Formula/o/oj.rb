class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.21.5.tar.gz"
  sha256 "57998b71bb60b2463abf41c26ef5c5272769ba6bf97114a76056a1950b90f7d1"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdd24f936f64f02152887d9e3522b20e7b737fa55fe83add8c4e23f35c0307db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd24f936f64f02152887d9e3522b20e7b737fa55fe83add8c4e23f35c0307db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd24f936f64f02152887d9e3522b20e7b737fa55fe83add8c4e23f35c0307db"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ca3d58b6b3b8f29a30dc363c998e6d51a703f21a946bc80a4c85f3f9de4f59b"
    sha256 cellar: :any_skip_relocation, ventura:        "8ca3d58b6b3b8f29a30dc363c998e6d51a703f21a946bc80a4c85f3f9de4f59b"
    sha256 cellar: :any_skip_relocation, monterey:       "8ca3d58b6b3b8f29a30dc363c998e6d51a703f21a946bc80a4c85f3f9de4f59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8851f63a6e95054dbf6c3ddeb6264fbc3f918a80c8c178830c1ca64f6318a39e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
