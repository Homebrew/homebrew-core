class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.17.0.tar.gz"
  sha256 "e47bf87a29cede1f190624dfb63f3fe289eff4b63ef2c3caffc972be2659d74a"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69ff245770064f4c0281fcc061c9d04066b146ee49c41940a47322c1875f9989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d0f199eb4e4ce0303c0a6123d0fdd019d902b29278dd374c8586648f65409e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b847f7f201ca8bfc0e5a1b4455c808af7869cfe3c0ce76d83e98c2a32134c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "60bc14c4d6ccc66527f916d6f131ead2b6f78d7a106894f75d41c69c69a7c443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9265010cb05e7ccafc1785c36e0aabcd44f7d81711210aaa79c9e66f63ca4d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c23a7c73a4a790326304b793add2e11ea1be38a93e0e6c2a82cf42876a86ba"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
