class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.12",
      revision: "6fd5337cc272289463eb562606e67515f48b4aff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4f56ebb860ee23e8c18792962cb03d16409252106a3f38f370da029baa8c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4097503e3348206114d757b8f532fadaf8868eb3de2c1cb4795a4bb1ddbcdd0"
    sha256 cellar: :any_skip_relocation, monterey:       "1677cf0771a5f9bb9a73099b35e973dc09e5509cfba53a16f6dd01c7ec249472"
    sha256 cellar: :any_skip_relocation, big_sur:        "9854a209f403c2e2fc43d69cbf8b42e3e80844992c31321c7b960f4f187d093e"
    sha256 cellar: :any_skip_relocation, catalina:       "ac9d6261cbc3e0827b4d7a96666340e0bcd13ed177bfd115a6248fcdb63926e0"
    sha256 cellar: :any_skip_relocation, mojave:         "99ffcce11cdc7e5e61e28d81255c9eba0dfe5c004919629dec01b3dc9a71f878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "011b4cd8ae02e19eead518ce13329cab6afc53a13acc41b87c24142d34d2d1ea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
