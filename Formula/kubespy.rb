class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/v0.6.0.tar.gz"
  sha256 "ff8f54a2a495d8ebb57242989238a96c2c07d26601c382a25419498170fc3351"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69660697d50488bb1c7df1372afcefde7ec3884396e36acba34384b63bd17607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f01f8a5ff0489b2f60c6e05c3e2703e8ed304cad34b4f5b7be5a386d8c291657"
    sha256 cellar: :any_skip_relocation, monterey:       "17b69ea07e1644c95a85c0eac40922be7e0468895f9a677d10d2277efc1a7455"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cd06ee898d017e009d6825ced4f01859987f9bfa0d41db8d4094268b880553e"
    sha256 cellar: :any_skip_relocation, catalina:       "c803662722beea17aa638cfab61ca1b47326ca4e9c6fc8522d3e8776c43cb7bb"
    sha256 cellar: :any_skip_relocation, mojave:         "02dd7561ce07c576d9ab3de63dbcdf0c43ccc75a00260f44b56d036076059662"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c573da0ba80217ac5ce529fa070b5ecfb398e1554c93f1d824b1df9bcc16c406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4dd3522e26e234773a2cdd5ba837ccadcbe4babb7f5889faf8c11dda1bb10d"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/pulumi/kubespy/version.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "Unable to read kubectl config", shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
