class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.1.5",
      revision: "f95ff4f06e9f29c02c1600691b320a50a12008fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eac2711bcbef9a5cbb7f55ceb6f114bd1f8be19e84db9b86621718d93dc7b0a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "04fedf607091c23517d56573b22379f46697c81e58823cb7de34db3e70fad123"
    sha256 cellar: :any_skip_relocation, catalina:      "bdca9cb27e55690a26ed4c69266f4d669ed63d31048854abf33937ce143ff80f"
    sha256 cellar: :any_skip_relocation, mojave:        "c4837e4eb2be08d075524eed2a5daab351393fe473c31bff50a06d9740daf107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d993fbdc56f5a3147c36e9de8bbc605b4059d4d085e145d9b4dcf080dfbe636c"
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
