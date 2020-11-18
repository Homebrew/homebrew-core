class K0s < Formula
  desc "Zero Friction Kubernetes"
  homepage "https://k0sproject.io"
  url "https://github.com/k0sproject/k0s/archive/v0.7.0.tar.gz"
  sha256 "5a697bf9f99c9dce7077b4bfa9323759cb54b49983b5544f1b1564447890dfef"
  license "Apache-2.0"

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    ENV.deparallelize
    system "make",  "EMBEDDED_BINS_BUILDMODE=fetch", "VERSION=#{version}"
    bin.install "k0s"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/k0s version")
    system "#{bin}/k0s default-config > k0s.yaml"
    assert_match "apiVersion: k0s.k0sproject.io/v1beta1", File.read("k0s.yaml")
  end
end
