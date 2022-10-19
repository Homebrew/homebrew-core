class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.12.2",
      revision: "d1dff27842c5364fe0d03fabc517940b8d7e5805"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9694942ff404b6666b8fd3be5ba82164dfb7a0dffef50b7662e17546d58023d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f23e9c4ef10e9f7fb04ef865ee5652e401c735c1479184adcc835f0e53fb4b6"
    sha256 cellar: :any_skip_relocation, monterey:       "3abed5853e80766a62527a183f5316788fc35d37c515de26dd9b922d895a13d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ef6948ec5c24a949a1aa64f285891becf841aac28204cfbcfd73cb66bdbe72b"
    sha256 cellar: :any_skip_relocation, catalina:       "39eacd799d0cec591b2c5b0cd675f2dcf0dbdd1d5e397c469dab808fabd0c690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "625a03db2e7392660ef6f1e8163fdfe3c6a749695b4347fdd6e1f7c958b01cca"
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
