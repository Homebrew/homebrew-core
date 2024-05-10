class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.49.1.tar.gz"
  sha256 "e898bcfec71ee1b5eba3bba0816eaca5f735e7443e11864dddbf753f8ecc3cf7"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00bb132ab53a6f2c709506702ac7dd8d462a1809cc2b6fd32f56dd96ffe48553"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ee48d9c2b2fccd3aa586f2282aa6da02cb77b95dd4374c2728f78eb95c169a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e212e5dc30adcbf35573a8fd1ad05981b4a0174f976cd52ef099d3f63d7c589"
    sha256 cellar: :any_skip_relocation, sonoma:         "16f6160ca3eb3adc7dec69877853af27a728405726383bb0cbb120dac902fa21"
    sha256 cellar: :any_skip_relocation, ventura:        "d9ca31f951bc1f666662bc978835c200e43d4d41679953fd5d24e50d89458855"
    sha256 cellar: :any_skip_relocation, monterey:       "a356c76dd04a436e1d661dc00fb3d66c10c5ad3060ea7483ac78b43d1b54ef9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "439ea048f13a2aabfe85cc59125c2d8e711938955fd6f3d3622c993781c798f8"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
