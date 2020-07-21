class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.9.1.tar.gz"
  sha256 "e5a3b73780ed90660e45e268669fc648bc90bbba59713b1594dbbde76646970a"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "490b8012e91da9f1633313efcdb2dda317f90ee6d01279618aefb0671cdb8e6b" => :catalina
    sha256 "6b7414353380fb75ee82875fa7f71eaa008f6dd7a759d14c9d4c5f5e63b9d3d3" => :mojave
    sha256 "d47583dfc5d86857b95ca055c47ea0c68c7a59a5ffc1f98afcd4c2ebe11e8595" => :high_sierra
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
