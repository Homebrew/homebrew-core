class Istio < Formula
  desc "An open platform to connect, manage, and secure microservices."
  homepage "https://istio.io"
  url "https://github.com/istio/istio/archive/0.4.0.tar.gz"
  sha256 "7e8214c4141655a1ee49cb7e0ba9bf95e003c08173e5a723f2e98c7d5f121fce"

  depends_on "go" => :build
  depends_on "bazel" => :build
  depends_on "buildifier" => :build

  def install
    system "make"
  end

  test do
    system "#{bin}/istioctl", "--help"
  end
end
