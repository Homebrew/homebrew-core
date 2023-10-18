class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.1",
      revision: "f496587bc5e9d9061dfcf82ad9e913ae3cd4372c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1d77c21867a5fcb85ed70e95ee201df5812d9eb25887d52c3a3997aa767882c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69bebe361766001acc48859d442d56a07af3a42a092d14377e79b496d50301e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17326465dc429a5462d607e528c14903a93412e78523deeca9f83a657b5c0c93"
    sha256 cellar: :any_skip_relocation, sonoma:         "6226c708aaa645d63d844290f91307c148a35d162618ad4b13c3c1a7c56d9023"
    sha256 cellar: :any_skip_relocation, ventura:        "47c3a228285ce52382d613ece9927a6ec39f14de47c2c98366699a2f1eb08c66"
    sha256 cellar: :any_skip_relocation, monterey:       "c6518138f528e2a69e99b59c96f71ad1a3419f0f71b448f1cf250e9a10d913aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6d1eb687c8e4c32de9d8fcfea56a337b809ff4f1a747e6540d995e802d0e8a5"
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
