class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.13.0.tar.gz"
  sha256 "bddd4ed7e29ff8218c23ae2f8e0834b762c60955f53ebc10d07329689c3a9878"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47f594c1b7a61a84ea2572d74be37d0c356039fdf6f612fdcfea693680f80954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24daa6efece92f49efaa044da193f5586cd1292837b2dae9151c2f05be3b7067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c79b1414f219355bd3a212d5af3e44bc01c327f38a1f680d1d72c8306b0f6cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ec613b3f7585abf5c44fa836b6c4a4527a5692c0ca901c002d3d17b9389d314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53b93b66cdb70c325e0e384ae04f2d3b6661d96b059c0a815f481b3390ee35b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb065b04eb7797a84f0a38199c1a18c833873eadd8df8762908fad3268cbaf3f"
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
