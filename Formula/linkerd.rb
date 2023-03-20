class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.12.4",
      revision: "ec4bb714e9fed472a379618e1b9a01317b2425b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b2aad31f1471cb9542677e51218dfbd048d366c5cb0237b4a3b4081147ee64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1e383fd4aa1ea4e73ef6327d679e0609511e80b17e617f80a4717fee860f17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41a17b8a0c256d6a7d454016b95fd09d0896f145de583cdd776419763a4c8725"
    sha256 cellar: :any_skip_relocation, ventura:        "49a985dce63bdc21a38d405b3bbcda5b083aa64167c7f7e1f9e607ba7cc2cdc4"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e6cc196017c1fa0037a28fb486da2a19b5499ff538d51e24c2149ba849cf2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8914d22438db4f3a779434fcdf7864a7742a84ee9e2cc17e89f10a5946df8bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c1a0c6a3c115fa9fb4ab832e5c01a50d37156c0a5fccaa4d84cdf01f566a23"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
