class OpenshiftCli < Formula
  desc "Red Hat OpenShift command-line interface tool"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.7.2/openshift-client-mac-4.7.2.tar.gz"
  sha256 "21d18aabc0b15e89d82d94f3a4e67737497000a6e701d746f8394a9197d74848"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "kubernetes-cli"

  def install
    bin.install "oc"
  end

  test do
    run_output = shell_output("#{bin}/oc 2>&1")
    assert_match "OpenShift Client", run_output
  end
end
