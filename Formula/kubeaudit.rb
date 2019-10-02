class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.7.0.tar.gz"
  sha256 "b8f97a42fe617ec9cf07931f4b74f02b31676e8b8e8930c0d5f8db380b27e670"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c06225ef9cfe1a90ac1ddc2dbcea35c8320583bc657b718cfb368320d120f800" => :mojave
    sha256 "939d73123b64b4f7c21f83309c19ba68f36822d648fe859a2174ded19492e06a" => :high_sierra
    sha256 "e82a8283d1be4e9ded6d726234cf24eb075d1ea457e5235d7849a066d39f1eb7" => :sierra
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
