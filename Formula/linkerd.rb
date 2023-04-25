class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.2",
      revision: "381b37568805399fca4cc041bd4915a98338c1cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "956250735a5a3b072a0f4d3cb7f84223d302aabab51ac43963bf2d6b99237c9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb33f6f338ef075e44c50b573b4170013c0031a765b80ada71e67fdb7c8a5af9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8bc4bab3b1369fb719c9abcb6621051cf36cebbb7b945e958a79477a2a8fabc"
    sha256 cellar: :any_skip_relocation, ventura:        "a0647765c7d81068d66c96f7a1c4266efe4f2aa5bce27efa68ac5b6939dc50b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f5fd5986ef0121a0f04de1ecc6879a54c836284d28da7bc1858892d6d990414e"
    sha256 cellar: :any_skip_relocation, big_sur:        "60592f5e74d4ee964bae712fd6b9fe058361c62f7ce91eb950f4e99d0f11ac8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06b7165c30de70f2b273fd83e3bd700bfb30f276429c472b43e22d95a6a41cb"
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
