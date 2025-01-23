class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "a59fe54d60230eebed172a2e72459234e3dfe5da5182608b4e824b023fec878a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d5be59928ab2ae38da14eb95d901aad6481990f3a03236110fc4401af18c792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c423db2972d7c09595cf23bd02d0cc5d99243a18e164619671b5a4d14c9dda6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6caee0d316df1687028310160b5ba2d9b8a31848984ec2a4782dbe8a1f800c9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "395417618479df8dc0cb8dce9ba60862963fa88b110b9f99e05a51ba96c14acf"
    sha256 cellar: :any_skip_relocation, ventura:       "b275b71402142c4e48f87ecd87a72fbbb49f4b55efe377e5600def0e86336303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a823e6b1b8f778dfb5aec182617fcfd9938433eaa8b4d325a5dc1358c4ceef5"
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
