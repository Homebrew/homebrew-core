class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.4",
      revision: "dc18965b45b13ed3544fa27fed01ea635e252c37"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dceab39d880a967ece7aa4ff8b6c5dc2eab30709b4f5bbcc1f81044ad85d7818"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de9a6f94436bd3f46b2b64317130821ead83079ae5207757f27b42c2ee796050"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b87c97bdc305f9b9da9c1742b04d999f1afe0a27a67a81cd3ed5a273b3c4651"
    sha256 cellar: :any_skip_relocation, ventura:        "336201a8571be5f75fea1e98e503e436b9e5e1be284b299d0d886b17e8a594a3"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5e7afe71da2fd5317873aa06863b09a5cf74c035c381db72e1170457241b87"
    sha256 cellar: :any_skip_relocation, big_sur:        "417bd0d5003874b0b7af83c70dbcdf3eab2d58552851bdb4d0b478a3306ae2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2613ff106141e8654524a2ae83b73630c30dfe18e13b0336c405b7b46ac53b6b"
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
