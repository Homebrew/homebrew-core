class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.10",
      revision: "1ea6b271718f90182bdf747490895784988e980e"
  license "Apache-2.0"
  head "https://github.com/linkerd/linkerd2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "92f89d28c0b857ea8f76583f7ad385ac68156aa36e8a1a144f960779f0a85d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "38c1c491271ea2f1e76a50c01f919f24528b409311a6c5e0b5801b8d7b4df78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dd8a49fcb56e1eab62825fa310ffe6966d9aac27ebf4356b0f2be56ccb7d2ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd3045e2d699c0bb1a16619ec5b045fae1d92293a3276c754354c3d201cc2aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5e275b3c5a026354bc0db5683f6044b75e551dafc0d40dd70144a9bc374b61c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a805f780856c04434e1cf56bf9722ff2d72e78ccbd4cd2bfec4b4667dca06084"
    sha256 cellar: :any_skip_relocation, ventura:        "e5c1ac2ba88949aa2e98ca4e39d5532a33d14cfad608d8776bb2f10e47cd4f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d982f58ff4958cc8a9cfabb65325d72dceb0c01c3b2c6200473868fb526a650"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "77bc80d5bd80767167b7895ab1afb69da5b45ef309cbd29db4956208ed8af55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1695ba96f330ebb2cfe3267a5e3cb4e77b092410ac9dac2465a977317d00945"
  end

  depends_on "go" => :build

  # upstream PR to bump go to v1.22, https://github.com/linkerd/linkerd2/pull/12114
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/linkerd/stable-2.14.10.patch"
    sha256 "0d634f7ca5036e75435a10318f3e6a7d6a5c40ee0c21689a5f1814dbc5ba6911"
  end

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: #{stable.specs[:tag]}", version_output

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
