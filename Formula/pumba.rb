class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.9.7.tar.gz"
  sha256 "844f600da305577db726cd2b97295608641a462a5e1c457de14af216e4540fe4"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4405e5f50375cf179431eea009797d0474658c4728c564bfbcfeff96b02e51c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "005c8e9c537ad08a2da596a094af003133ab0b75aaf35c45959e12fa9c7f1eff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfeb22a1a5f348a525aedb9ef8e22d5c8a974b2e6e4c85ed7a64f8e3b7b99839"
    sha256 cellar: :any_skip_relocation, ventura:        "cec7cde030bfae611c8da594d78cc7404e98a47e3f3f9113152e337b4a483ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "f59ad191fc02d799096c645374403bfb772b7d81dc6f06b20bf5121076a8d765"
    sha256 cellar: :any_skip_relocation, big_sur:        "c981dda5cffe70dd150490ac68bf2ec7a33de222912632865cd9f73f877488ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ef073e593b652418176ed0fa74e613248ebf9494c5c0fbe5941fb9f8b88e3a8"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")
    # CI runs in a Docker container, so the test does not run as expected.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
