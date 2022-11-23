class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.8.2.tar.gz"
  sha256 "2f76b60302abaea7b2c8cd05e7a2c991c86b4667074434e3ff02dfaec02fc291"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f81b886cef62f64af8689b8400ee504d7418d321b0c1f78be4553648208a2cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66d1d3f6d6b6fcb5198cb7424df5bf8394ccfac430ccde74749c038b2574d337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b46b3152a0da9e77efd0945f04e890fdf0e81f971ff00432439910311b58eabf"
    sha256 cellar: :any_skip_relocation, monterey:       "368970388bbff4cc12b594e8ef124938cb9e88370f1c22af015444157105c32d"
    sha256 cellar: :any_skip_relocation, big_sur:        "af07b37cf9c31b5a57f86aa4cb2e58a9fd711822e252ee3cb90dabd83bfb9cfc"
    sha256 cellar: :any_skip_relocation, catalina:       "079d7778c59ac899c5075b520ac4db2a31b3af5fb7ec55541b92b3ef22fe94c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944bcbc111c057da77e3ee78aa9edffbc372895007a188f119aec2e542f3cd19"
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
