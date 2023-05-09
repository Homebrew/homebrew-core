class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.3",
      revision: "216047a7ec271e364a1e90d2c0b5520c7e65d538"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22319e96ae42cd36d658433ab67ad1576869bbf583e391a46eaaa22a9873e792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1853048fc8cb62bca60b5ffc9ac415178f150b24513b2a50adeaa3cb61586e29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef1d548380f70daab8cc625cafbe98e594b9505f00417e8655729f5893204144"
    sha256 cellar: :any_skip_relocation, ventura:        "d9e54ac97a657fb74e80b6bde5a2d1b87b441006cfebd7f60d41eaab857bd202"
    sha256 cellar: :any_skip_relocation, monterey:       "b1f0119c7d1b5c504eb5597379480831ee19b3dd6a5f2da2ecf2d5055ef253b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c2f0d45061db83b7d21a6fe0e57a5b1c4d4bbeacc8b2e292a1c290ed3edcf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb0fcd96d6afdc97ff5051cc13aa9253c186ba770c1209e795e16de0a864523"
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
