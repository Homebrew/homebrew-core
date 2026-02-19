class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.11.1.tar.gz"
  sha256 "e0a205479a5a1d0db51b30febdfe5a5410f6925a586eb41c2d46e3fd5e34c91a"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f47cc5f3873e91231ee36a5d7d40e4ed2a750a98c430bca7d45182c96a91b9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0770f2f984bf5b0ca736bdeb4964cef10b8f498affd5471b94a3f7c3035278b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8150910418e16d04165c9c2b59d74075fa71876e04c5bd16317ee3ed1a337cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b9adea6553595d7a3179d766d792a4d75da4a2bb3bdc5523177351ec63fa694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd169860bc589a13989ff937a4a925bc3e754c38953b5ef66e886be1de898825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3491b161ce802907a5d745dd69627ec1abdf6b516f0afbdd7116a02229e38f51"
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
