class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.7",
      revision: "5902ad5511acca15a2dcc7a0339f8d853fe66e78"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa32fe26f999f221dd348f08fc43a810a2bc70c9ddd6a48d2d46d6255be22f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e9ff9df6b66c86d22875ea3db5d68991606a16d53334cce8ce7030c5ae3f2ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cac2d7d17e4591894eb6a2265c003901382b38ad4e6f9ab802fdc10b7d112bf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea751a3ac833fbfc409b4abe1f15879ae9ee2c11c5ac8b5c6230b2fa487784ac"
    sha256 cellar: :any_skip_relocation, ventura:        "3e798528da590e5c29f475806e523b2a059e54029f916633af65c66307285f42"
    sha256 cellar: :any_skip_relocation, monterey:       "66b692dde9061b54b7bbdf2abe7889e18601df370e22b408445bea87f28c1b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50c3366ac0038db6f9c5b1a3e9dcbab30a814f79c8b4bf4959332ad311bb55c9"
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
