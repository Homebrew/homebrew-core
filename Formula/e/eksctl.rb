class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.182.0",
      revision: "40a6990a0f86086897c7a660a95de2b55f8dc1da"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad5a64a30146ea2887980e76ad8f922dbce87482aae4c843bd6ada9af6666650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "103e91505e937ef14e71d6be5687d7ba9ad8f59cc2890eb919d981147c617076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf279c443dd80f5502d737dd9ae238e2ed97aa0487b33c75a152e8e8751ec9cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b786a9518b4abd4309e2fdf27f98c42981901722cab89b1a96713aaa97985af"
    sha256 cellar: :any_skip_relocation, ventura:        "4a3649940e8021c09ff1b447151bd2ce98af20c51cad4ea79508556676a2c7cb"
    sha256 cellar: :any_skip_relocation, monterey:       "c6cbec2c7aed8d4a87c23abfb7cb814724f3063ae3596c0eaa53aaaf6b00c2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50f47321b50c555c7e4e69cdd705ed474a393dc759191c6df91355209cb0747"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
