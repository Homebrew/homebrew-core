class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.34.2.tar.gz"
  sha256 "85931a3a4fa1e16973a7861a4cc70cc783973641556ed433ef7a9fb02f110f7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c540a59a784f369f60803d815053160bcc8e3dce00575fc17585bda2555034c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9371c309339227006c6ae219924bdd6e0714aa9666b09e5e01405d3eb75f0754"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae499604b90aee544079911b53381e9696aa42bfb41d3c400185c9fde6a4c9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2470fe11445abda7bdbd3302cc4da027d6d132ffffb89a295605ccf89955a430"
    sha256 cellar: :any_skip_relocation, ventura:        "010d6e1ec67cb77ed3cdb0c9f04d719b8686727b5c0fd672771d8cc97320b110"
    sha256 cellar: :any_skip_relocation, monterey:       "da6577b8559fa9ec4938a040a13f4645842a4d2c76244dfe573827eb25115ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f07545fc95aabdb01cdc67247ef6930c360b60a5bac2722cd1eff88797fb1f"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
