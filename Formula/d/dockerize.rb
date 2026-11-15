class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "f24dd9242c203f96c199c66c05c43a12acead1b11ab4266c1e1ab6bdf3292669"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd430f1fc5bf30a3727ec695ad8ab543d876cfc8094fa94eda927c17895c439e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd430f1fc5bf30a3727ec695ad8ab543d876cfc8094fa94eda927c17895c439e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd430f1fc5bf30a3727ec695ad8ab543d876cfc8094fa94eda927c17895c439e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd424296ea9024429f7f7a3db214fd99a82323420b937339be043ef6fb32a872"
    sha256 cellar: :any,                 x86_64_linux:      "61bb0b91dc6a49659a1c83143db5ef75f959aa746a2985d29f1b64b8046f78e3"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
