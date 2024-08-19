class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.189.0",
      revision: "c9afc4260a9aec3cd9b545f501e64a77cc7f5c26"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47a7cc845693bc768bf4ebd6801b8d6a89c09f7139d90dbec219b53d1af297ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e92aa5b6db7cc58a23d5584502ac18a2a0f867954e14667fae7fd5e117b48c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "825064b586fa1c8c36ef229539b599645c1f3fe93d98d8769d606e677b8df0a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fb0ddd728aab453c0db8735b3d47da78728c4a68e4a373a514d65b6d3795ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "4d5dac01b1fcd46e1e787f9ea78b1ce3e90835428cab2361f9973fdf37c8f700"
    sha256 cellar: :any_skip_relocation, monterey:       "13015d6e6743a78eb88afad37089bdc67f99a807f09b5acf376d40eab1d9eef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29daca0658abed4aaac5a4f21cddf460c321979ae0f570fdb7ef14c4481c3ba"
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
