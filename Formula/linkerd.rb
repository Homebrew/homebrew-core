class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.5",
      revision: "da70f77695bbbd81abfcf7ce746021b3521ac14a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0009eafd6b3954161d0d8036b2d819d1954ea9031d65056b3cf8b0dbf52344bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c32a51540a76438fe69577dbcb593c806d23855f0a3be206c6e29e9f3be6f655"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d63299f3d071296261ff372cf44ff8ef12dab71af821c95f6033fd41a7ceb971"
    sha256 cellar: :any_skip_relocation, ventura:        "b959f253203d86433841529577af5d4c8f25f5bced5ddd91195de68cf43b3689"
    sha256 cellar: :any_skip_relocation, monterey:       "c3bc34d1363e9ffc56757f4aa53b99a8ed993fd6b890e696112de94b0e5615f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae2f078030c660863db20833da5652e1200eaece6dbd435990b5ff35b3a738ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4abbbbe32c8be46e8d8786418640250ad9428165e30b3801129fbb8d027fe8a"
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
