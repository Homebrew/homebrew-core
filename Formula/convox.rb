class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.8.0.tar.gz"
  sha256 "11b2a949dd45bb3fbc3afae2793a372b8bacaa939691c4e6962517abd42625cd"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deffe823ab4c24aa5fcf93ff294093936bc611b8afc29c218ea6b920d52704b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c10efe8c9ec5b14c33104972939549d0e5deb004d456e8b874d431a56ec6d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53c944da5e44d2af775e565a0c6760f3c1a9c41ed1cca15aff8def70b1bd01ce"
    sha256 cellar: :any_skip_relocation, monterey:       "1150401a1c52cab6515f45becb7d2d2ec4bad7234312e8c6a63c9b5791589469"
    sha256 cellar: :any_skip_relocation, big_sur:        "01c5a981aa46dc94696d5bbd0c210cd4858f2f281dfb310c202a6e500f36dcc7"
    sha256 cellar: :any_skip_relocation, catalina:       "797dabf8033fdf9a9b43077db95a5e3b8d5cfa638aa3ae1df28ced1f86c45e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a665c1162b5f342044ce00eb4fe5dba60c5ce1165d2b0f922c293917d437d45"
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
