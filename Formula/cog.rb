class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "bce8bcedefafdd7ebd498b9f94eead6d2c9586ae36cf6e8c1dcaab8d15927505"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda9283c6664d3eea5894445ad0370da4838eb8b16b4d04baa857b1e46e96591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "980dc7c1f37204ced2f5b138225627485201b8d0112f90e80cf3d0ea822e89fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92683ac1cd1e3e2fce624eedfeebb2b8adaea038cd7a923e6a002f0f7cec18f3"
    sha256 cellar: :any_skip_relocation, ventura:        "306333fb01c0260f19740e617368dc1f0f908154b46d63b169ea129eda9c2f30"
    sha256 cellar: :any_skip_relocation, monterey:       "878856bdeb8101db05fafacfffd63892985de5b4813a9173478a58aa10386af6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9019f89efbe6a9ac18e30dc822dbffc5593f6ccb8c25638f20ac0c2464273e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93bad882f8bccf28590e6a4bd19654d1038773124d1e1e215486f60082c9e636"
  end

  depends_on "go" => :build
  depends_on "redis"

  uses_from_macos "python" => :build

  def install
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
