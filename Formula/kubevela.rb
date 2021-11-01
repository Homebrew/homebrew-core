class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.1.7",
      revision: "d083039a321983fc944ad1da1dcd1bf5e7a81255"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf45d5b4b27ffb8518bd9465ea6e0721a4329c35e30c7db25aa5e1090ef1c00f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fec88279635567e1eb19eb67c28ef17f6a97598ee7a374b1cf5677cb059c1f7"
    sha256 cellar: :any_skip_relocation, monterey:       "1a75a82bfdba128a8d3a2df90d91fe60268828be6818fae1d005df7e1546878e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4dc957b39fe40650735083365dcf48071c11b006cdec862735f8989e5d383ec"
    sha256 cellar: :any_skip_relocation, catalina:       "6eacb9b99335f1b1b94de877b04729ab5a59929e2950d607e36ca8a76d200ad5"
    sha256 cellar: :any_skip_relocation, mojave:         "8a2af8b01b1bc0faf475bf86492fd1981fe896a42efa23d245fbc246756cf092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5c711454e3fc81fd4add17aa995f7bb014e09f7866881ee5ec4cccb35d3944"
  end

  depends_on "go" => :build

  def install
    system "make", "vela-cli", "VELA_VERSION=#{version}"
    bin.install "bin/vela"
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "get kubeConfig err invalid configuration: no configuration has been provided", status_output
  end
end
