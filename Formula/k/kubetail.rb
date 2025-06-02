class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.7.0.tar.gz"
  sha256 "cce8d3aef284bb4426f31984d716b4de1a8facc1e9e47b5b8fcf15f49244611d"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30c0148c83be700d8d82c10422a7a01ceb4148b90a867436c5eda764b5dd1b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf08fd7fb57ed8e43ff0a76f3b6032c74e0f55d97f403e8db74ca475c1f503bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc7351c16e403a408ecb8f137504524d66f3f1b43335ac742a20cd9e006da3f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ea4dbac2591147866dfcd26342454b0b5bdea06b3b7ab8ae4e894e3f9d8f57f"
    sha256 cellar: :any_skip_relocation, ventura:       "8eed5c77f59b577fbd63c12e6807a34eb443d7047772b67d1bd7c5f16b4695f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07b798367f616f1bd21e52aac26f89cc8beed76f34c3ce23081ec7418aaf3c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b0b4b6a4a4e58f0725f4effc6c223d184b9d68c495af22db1aa6a48a6f0d204"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
