class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.4.tar.gz"
  sha256 "06af1e84167c381a97d42a54c1420d5033a5757c834742bdd66659054593e0eb"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "730b054a56e802a9499e147ae83e452294f215484a915ee074b1d40f27e6e4a3" => :catalina
    sha256 "c6ae841973747d42f2c45193b33fc8f3627c2c23077aaf655d56799748ede8a8" => :mojave
    sha256 "c5c81b1fe8f0ec9c1013b5b6a4357529bdc54beaa71648d52f0acf89788e387e" => :high_sierra
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
