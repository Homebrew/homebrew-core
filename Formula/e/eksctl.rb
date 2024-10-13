class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.192.0",
      revision: "65610b3b47b6d5da95082a59cfc14f1dc368eb0b"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd03f576588d1962c047659d580c8a7aa6ca6e010be2ce884cb716d3e3bb26e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d9ff9d2d3996cf1c505a5b66de3c497bdb3ec5a4cf3a816a51d4024ee98e9b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ca7d00f3121b08774e58def56b507d76f651bd4525e086b862a511b9600000d"
    sha256 cellar: :any_skip_relocation, sonoma:        "81358acad701421086a22838a08af2d15061ff50a77b917316e22087bb90ab07"
    sha256 cellar: :any_skip_relocation, ventura:       "42556b67d79240e01a9429549cd8b2f6f92b0708e7761c578d97d67f64edca1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "081a2c50f08de600f5471914989b9b4d3681e9f1f5d7542a3d3e56e43e4b517b"
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
