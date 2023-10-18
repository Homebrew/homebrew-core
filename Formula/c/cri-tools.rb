class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.28.0.tar.gz"
  sha256 "e32eb97d8ab6dff4a772a9672a19b62b65dd3bd71253aee64ba3d5109e86e058"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "738aca9646db78a2b1db05cf48750c7923abb98f23b0e987be6ffdf5a3310457"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceb325c4f7212c686d7a42c2950dd355b89cd9411019010be9f558435ba273c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb325c4f7212c686d7a42c2950dd355b89cd9411019010be9f558435ba273c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceb325c4f7212c686d7a42c2950dd355b89cd9411019010be9f558435ba273c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8496f34bed353a9639aa6947260ba987ce534eaf77d7df616a9c7d5151a5859e"
    sha256 cellar: :any_skip_relocation, ventura:        "79312a2e1d2d2065bbe9b981b5530517241c58e1fc1d17a45a0aa74e600bbaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "79312a2e1d2d2065bbe9b981b5530517241c58e1fc1d17a45a0aa74e600bbaf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "79312a2e1d2d2065bbe9b981b5530517241c58e1fc1d17a45a0aa74e600bbaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2d9a78fb271d04dc9d639e0ef363766deac912187ccc19127cea8b144b902f"
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
    error = "transport: Error while dialing: dial unix /var/run/nonexistent.sock: connect: no such file or directory"
    assert_match error, crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
