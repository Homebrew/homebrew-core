class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.1",
      revision: "59a40f58c9914939aee49dba85c66592ffd14132"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35b18c77c1b6a94eba4de7ee7c74c13a3d6b1b9f7b553809e8729301da846771"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fdd16ff0449e657e881dfb7538f8beabea55d2a3bf1dbd520a241f02426feb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "642ae51b14ebc09dd6e665f35928c5d68210f8dfeeebc63360ecf9b8c836b692"
    sha256 cellar: :any_skip_relocation, ventura:        "d50a34355dbe60d48be6cb495b0925884172b2c0065df167529389e9a4ee525d"
    sha256 cellar: :any_skip_relocation, monterey:       "a210569694ac4d0e6adef6a49ff5132a77505f8cf0c632b235c37ae69d2e666a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9cc4b23619f9365a7caaf67cc3830c5bee9bfb5347918a230cd4a59e7b6436f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c3993c72d74a6875b321002b742d814ce96eeabc025b841cbcc539a526d435"
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
