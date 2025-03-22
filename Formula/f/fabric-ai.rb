class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.163.tar.gz"
  sha256 "afd64502c79a88b292428d0a8756b1f914b9d5472612382c95183ada0f799feb"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8699a811601e313a3477da190680b2ea6fd1d35ea3d22c14cc56aebe9e567fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8699a811601e313a3477da190680b2ea6fd1d35ea3d22c14cc56aebe9e567fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8699a811601e313a3477da190680b2ea6fd1d35ea3d22c14cc56aebe9e567fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "77d3baea2c00abf4de4ea51340e7731b21b071c55efe105ee3cb932104ae846e"
    sha256 cellar: :any_skip_relocation, ventura:       "77d3baea2c00abf4de4ea51340e7731b21b071c55efe105ee3cb932104ae846e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef6557821defa5a062c54d0644f2b8e94fc5462e775b022c9b6be7d918a4330"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
