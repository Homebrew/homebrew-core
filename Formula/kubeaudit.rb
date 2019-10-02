class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.7.0.tar.gz"
  sha256 "b8f97a42fe617ec9cf07931f4b74f02b31676e8b8e8930c0d5f8db380b27e670"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b022b978cb987f15160d627be96d791e0249bc9668f8de2dfbe414afaaa01ab5" => :catalina
    sha256 "c0f6f178dcddf8577b2ea4172f7a2c99df4a46f02d10c744b258abfc079c627e" => :mojave
    sha256 "7848f34949fed2704f77913af064e484ea338ac2be1980b3b303d38e3da2707f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/"src"

    system "go", "build", "-o", "kubeaudit"
    bin.install "kubeaudit"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1").chomp
    assert_match "Unable to load kubeconfig. Could not open file /some-file-that-does-not-exist.", output
  end
end
