class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://kubernetes-sigs.github.io/cloud-provider-kind/"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "87a8c713be6b0635f7cd32832c40a929afd93ddffc57a03076a7574bd7dfc43c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f8d1de5545e141ab7617ea3269311ab3857aa7e6a44984c02f58e3dbac0d394"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1725a751ed6db0fab8bec8efe77a2487e536bf3e3bbbd63b4b055f35cb85e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3acd801c2cc47554fc2bfc0d05c07c50356da3f160f1c79068d4d1bfc4523bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6dfc5a7e927a9eabcddc3a64a79e9da7da48d2002da5e6460c90aaff762c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a53c2ffdea610a88da6335ab48b34ed0cc4fc1f365d97ede01debcae8bfc637"
    sha256 cellar: :any,                 x86_64_linux:  "599cb32b9ce4fac0bd642c328a8f8a76fff0055481fa6b5fd8018c3294407e5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"cloud-provider-kind", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 1)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Error: please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "no supported container runtime found", status_output
    end
  end
end
