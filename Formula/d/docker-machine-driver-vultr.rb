class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/vultr/docker-machine-driver-vultr"
  url "https://github.com/vultr/docker-machine-driver-vultr/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "451a6e31ab4e5fb9be2c2730b1b03f5039a8ac2b41f677824e1b8a15036ab815"
  license "MIT"
  head "https://github.com/vultr/docker-machine-driver-vultr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dda2f729047493afd3de8c833bad9a0d2a92ac9cda6756c6518e30ee7f3b865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dda2f729047493afd3de8c833bad9a0d2a92ac9cda6756c6518e30ee7f3b865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dda2f729047493afd3de8c833bad9a0d2a92ac9cda6756c6518e30ee7f3b865"
    sha256 cellar: :any_skip_relocation, sonoma:        "606c6391582f3353b25bf1c2cb58e7c5a0388c9df9aee77445e1b6e5e959261a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcbda52b4860cc84ddfefa6b21e9b5a9284324cc5e2c9451bf7ca7eb9747fe1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc02dec3304a23cbda77067ae6a1bc315265468eb40cf015ee74e8c04954a03a"
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./machine"
  end

  test do
    assert_match "--vultr-api-key",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver vultr -h")
  end
end
