class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.7.0.tar.gz"
  sha256 "b8f97a42fe617ec9cf07931f4b74f02b31676e8b8e8930c0d5f8db380b27e670"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "759aa4ad288b11224b5d8b4594df793e4c625768bfae76e39b81c36f84983d82" => :catalina
    sha256 "2339bb6cd8f87632ab29b7938507fb971e15ec30c5a297c2708f186a52ef2af6" => :mojave
    sha256 "696663bd106d38390d12bbf41731ed7e3cf2b2b31d8e1515eb164ccce9381aab" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"kubeaudit"
    prefix.install_metafiles
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1").chomp
    assert_match "Unable to load kubeconfig. Could not open file /some-file-that-does-not-exist.", output
  end
end
