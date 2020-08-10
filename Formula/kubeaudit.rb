class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.10.0.tar.gz"
  sha256 "f1d7b5f864d84140faebb7521e632cffb515b86f31913c3508740a73f2cdbaaa"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aebd09d884ebbfcede48b59fd74b7796d5210ae573c1f1f12e080c3f0317c722" => :catalina
    sha256 "9c55b9b53e3c8467813a212cc10151819553ba9628cd6a4c8d2803fa9d4374e3" => :mojave
    sha256 "118faff8f6a7887e090b032cf6a61e0f48b3e864d931462b43535642d179b1f8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{Date.today}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
