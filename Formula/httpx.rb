class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.1.5.tar.gz"
  sha256 "e79dc2cf645c5be833d86aeb355fa4431594b5ca2ec39e0e389a7274f6ba9c7a"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984c02625af7ee5226922ce63903cfe70e84a445b6e473a13539aae81528e73c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d6ed4ef0e8a8e60234ad08738f6fb4b62bb08bf5dc7f79da78e8b5309b57dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "3965d3ab8fa961dc78ce9e09f8b7910f8e000fdc6049827d6d613c0640ba6384"
    sha256 cellar: :any_skip_relocation, big_sur:        "481e7dea1a733c0e41046bbcefc976c05d9a4c2de019d134659f5ae725b52010"
    sha256 cellar: :any_skip_relocation, catalina:       "1cb4b0e5f3f568ec7fa31a57a3a4034c15aaef1ed66fe81c00b0849a9a23ddca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e24cd73c8037b47211123caa281380d378a750a298d26aa8065af56bb54a0606"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
