class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "ae4c7e74cec8870bf5fde76d8289c121ec6dd9e2a5f8c49e2d1164d9765fde5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dde05a8d2364865981ec326af77a9c75dcd8e798546328329d30f3cd2d71f723"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4221d3c99d1b8c55e19100ed9b21f12445d7c2446c9b93f1c2f87420f8bd1a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e60a383047c31b38fffed7bbf299ce56e66e6f5789451ba3fa14812f1452c61c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a7e3cf86e093727d09fe4eb5e35eb392b419fd7285196e31d5efddc7633455a"
    sha256 cellar: :any_skip_relocation, sonoma:         "048cc3b951176762a156342089e5331259f057b1517fe8382f2887088748c547"
    sha256 cellar: :any_skip_relocation, ventura:        "ff7a825f0733e1f11084e15540f1421bafccfb5899a0fa6c38ed6b17521eb199"
    sha256 cellar: :any_skip_relocation, monterey:       "8507fcd8905d98c24fe4cbf5b5bf5afde6b07c0870ba0db7ab1d2186a5159174"
    sha256 cellar: :any_skip_relocation, big_sur:        "259b468e4235ba9fd4cc547a4e94dd442effbb88b9c95bf674a4e9a61a1feb6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae722251780e3e9f71569483a2748057f1ec0f9146a08abf7c7c78a44633baa"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_predicate testpath/"clive.yml", :exist?

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
