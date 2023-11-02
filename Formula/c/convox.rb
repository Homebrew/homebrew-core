class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.14.0.tar.gz"
  sha256 "bf21116ace91ce8a95af27ffb86f5a4c1481179a1ccee70b056e882d31183c99"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4993ba934f57dbb1d8cc87f4010d4ad07ad0829bff0a7a1090b20a445936f8d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b568dd399238ecc8f1f5011b5b19e2307de948f0e4931224d64ca800521450b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d276357207c0d55e2de20997ea1725b111634d309199f424fd3d9d0aa8e85212"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18251605cae96c28291173e1de4f615f67a4fccaca616882d9606d53a5abcac"
    sha256 cellar: :any_skip_relocation, ventura:        "bb2627fe06cbb4d81046ce1549042814f63cc7d19d1ac8f5d30508d41df41e80"
    sha256 cellar: :any_skip_relocation, monterey:       "d3150c3ea1e409bf00c5d387ccbadfc3e48393e75c04d73cf0b403d93f916091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "736dd0e3c376e4c7cdb3794dc91d5b5613957da2783f22b843cc53246f8e4df0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
