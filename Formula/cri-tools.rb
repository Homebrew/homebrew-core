class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.25.0.tar.gz"
  sha256 "bd900fac00b3247fa601f7aca4e0e44825dfd67d399c2830cbc643b7d73dbe52"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8097362ca5f183af921dc2fff89d4c3362c3e3218346769323412cf92777430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5f657da6cea82cde45f04a6d72c28fb25e6f5870f9be5aa47ce7ff7c964129"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd5f657da6cea82cde45f04a6d72c28fb25e6f5870f9be5aa47ce7ff7c964129"
    sha256 cellar: :any_skip_relocation, ventura:        "9265bf5ad23e132bea354162dd58d6b58116c21b3266fa9f052e32d22cbabd5d"
    sha256 cellar: :any_skip_relocation, monterey:       "eb45b4db58267183690c0fb42b88c9b3101ee00eeaa6bf2792d49727f3043f22"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb45b4db58267183690c0fb42b88c9b3101ee00eeaa6bf2792d49727f3043f22"
    sha256 cellar: :any_skip_relocation, catalina:       "eb45b4db58267183690c0fb42b88c9b3101ee00eeaa6bf2792d49727f3043f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47c5cd871564a585cb68bf9d5a399704bf3bbbfa7372c856fbc7ca97f0f8446"
  end

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    generate_completions_from_executable(bin/"crictl", "completion", base_name: "crictl")
  end

  test do
    crictl_output = shell_output(
      "#{bin}/crictl --runtime-endpoint unix:///var/run/nonexistent.sock --timeout 10ms info 2>&1", 1
    )
    assert_match "unable to determine runtime API version", crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
