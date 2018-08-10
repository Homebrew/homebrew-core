class ClientKeystoneAuth < Formula
  desc "Tool to authenticate to keystone"
  homepage "https://github.com/kubernetes/cloud-provider-openstack"
  url "https://github.com/kubernetes/cloud-provider-openstack/releases/download/v0.2.0/cloud-provider-openstack-v0.2.0-darwin-amd64.zip"
  sha256 "83b5cf489ec2a8f5b5660290e26e88bbd413346cfce203a1b10bb5e2adaf5383"

  bottle :unneeded

  depends_on "kubernetes-cli" => :recommended

  def install
    bin.install "client-keystone-auth"
  end

  test do
    assert_match "KUBERNETES_EXEC_INFO env variable must be set.", shell_output("#{bin}/client-keystone-auth 2>&1", 1)
  end
end
