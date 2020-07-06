class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.8.0.tar.gz"
  sha256 "0efcbc176803e7a5ebc864b82d4cc6011f85f4d63778f0bae010f1d09b7e4d66"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d788171cf4f563cd2010525027e2f2359687610aed37e6af8c089a6eaeb69d4" => :catalina
    sha256 "6b7bc21fb975da2d7fdf2c43ca68821b5e1a4006f19ba5faa11fd16b2c19b2ed" => :mojave
    sha256 "4a88db513c8ba3ea81129cb64c620e0835e11eaadb03745630b00d414fbe76fd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{Date.today}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath", "-o", bin/"kubeaudit"
    prefix.install_metafiles
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "Unable to load kubeconfig. Could not open file /some-file-that-does-not-exist.", output
  end
end
