class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/v0.6.0.tar.gz"
  sha256 "ff8f54a2a495d8ebb57242989238a96c2c07d26601c382a25419498170fc3351"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cd06ee898d017e009d6825ced4f01859987f9bfa0d41db8d4094268b880553e" => :big_sur
    sha256 "f01f8a5ff0489b2f60c6e05c3e2703e8ed304cad34b4f5b7be5a386d8c291657" => :arm64_big_sur
    sha256 "c803662722beea17aa638cfab61ca1b47326ca4e9c6fc8522d3e8776c43cb7bb" => :catalina
    sha256 "02dd7561ce07c576d9ab3de63dbcdf0c43ccc75a00260f44b56d036076059662" => :mojave
    sha256 "c573da0ba80217ac5ce529fa070b5ecfb398e1554c93f1d824b1df9bcc16c406" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/pulumi/kubespy/version.Version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "Unable to read kubectl config", shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
