class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.9.6.tar.gz"
  sha256 "15865c6eeb108bc65bcd0aa6f3e270a7fed28854ea53eaa62cd0365c05d37f7c"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e52897528676100440cdeedca4d234ea962117a75e2a6b568bcec1d651f34063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a85e3affbc08452b4d792d73c8a7e7d3a43ad2f92f349de916af7ec4b8cdecc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "797ab3178b9a04ac6e4df1524ffb9b4fbc2c04abb513b60ff0851b4986193b98"
    sha256 cellar: :any_skip_relocation, ventura:        "06bead9146d31dd18b8b860562d3709de8d642e6cda77f14eb0cd7e37c2a2104"
    sha256 cellar: :any_skip_relocation, monterey:       "80c950398451fab2610e7d81d0c577341cddc7334298c8f9dbecfaa31ae0e075"
    sha256 cellar: :any_skip_relocation, big_sur:        "692d5cb6d4933d75210db0c4059226c33b552c02d245c62a6c4b742e2574a8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d64ee926c90ddcd7525361beff9ebd3cf59de08095695b353ba45f061d4435d"
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
