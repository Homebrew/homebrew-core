class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/v0.6.0.tar.gz"
  sha256 "ff8f54a2a495d8ebb57242989238a96c2c07d26601c382a25419498170fc3351"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "783702f8de5226fb50d35d30ee4f600f3c8ba82006e2ec52c6f643994f97ed65" => :catalina
    sha256 "0793f861231c44c23578b3c6d8faab29c868eb3ca4cc5786ad76536863fb04e0" => :mojave
    sha256 "a39ae5031e190cf58be0863d51738225366da5d36ede449af4146bd782b48e7a" => :high_sierra
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
