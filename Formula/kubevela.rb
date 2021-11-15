class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.1.8",
      revision: "066c448c1ae5a339e4f8dfc17b60085f137e9de4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2710a4a7230abf62aa7072899e597728f95668996e52aa3a4d2142acba2278d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91beb748bb1baea49a200b9e934fd30e554f3f8e99127383932963f1aadb47ba"
    sha256 cellar: :any_skip_relocation, monterey:       "effc058de8ae8c6fca9e9d1f22e9881e1eafe8c01ca42e66e04b887248939746"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb0db86500b6c4937815d8f4bb81911dc56c29e0389a8493b7544c282de8fcfc"
    sha256 cellar: :any_skip_relocation, catalina:       "7ad7c94a35abe1e6bdf149fa1ae556afa3a231cfa700ea0dd771bd36bafd26b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6897864cf9d25f2d7335ea376c13cadc89623b41e972ac001e838c91a79df0f6"
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
