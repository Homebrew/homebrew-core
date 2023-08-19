class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "7e83e5f185ed1074863e219cae382759e66821d7ba0d3a89bb0862fc80cc2ef5"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92ae7776c73b341f96cbf01cbe24f5b93838b06ef39e1146afacb53a474cebda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90f84b4060eff5b94d126b073a1774bfc692017e5fa23799dd0d7474ebf74168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d16b6aac79b6299a1b1600108b74b4057f1a72af64dee1d03252b2072f7c397"
    sha256 cellar: :any_skip_relocation, ventura:        "e48ad9f026fa7ddbfb7916b346cb7919d3678dce0ca5e5da3784a3538fd0ae51"
    sha256 cellar: :any_skip_relocation, monterey:       "ba958acf2f97b0c70b9bb889aae36e8d63f7cbec52dce9c23bb6ba40164a25d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e810fef9bf4cc329abdf5a7a8f0801ae0e7c134956a355d421c3acd53802c927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d09ef7df7733e089a01ab8c7113a9e8d0dd0d2c8fb7de7eecd4eb5c464d15319"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
