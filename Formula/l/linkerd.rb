class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.0",
      revision: "a4bec904cc19d30441fb4ab591cff0a1edc66c20"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01a1a32f460ad18a7ac4d7ca6255c9228a16241b8b9cfa1242c2e1be908001a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7ef6993b807f65d89b9a33a5d72c36be0f0f6445041049c40990550e91e06e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9db023bb15982852d8fd949078af1cfb38c3d7f5860272543a39e061ba7bd03"
    sha256 cellar: :any_skip_relocation, ventura:        "f592204342329b892545705044131c7428d0202533e18187a1e4e149dbf6e139"
    sha256 cellar: :any_skip_relocation, monterey:       "a1aa21ada7925fde8f256212aa5ce560988d4be4ff0785dd8f16c1454f1c1256"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fd4cf58794c101a99a07daad96a16d5a8b51b69402d876be4ec13a00dc1fd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c685c016df465ca12f23fe4ae86210cfb45483d6ec0d4feb513d8436b1b5e48f"
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
