class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.40.3.tar.gz"
  sha256 "cde329afd49edde411127ba65f91de68b0eebb359d968024990d1d6c9b0d19a3"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "212cef3efbe56a2b04cbaca3b24a7892e46629ee07551660b4754bd8c9b0acac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb44729bca0d6e0cbb790a087270bdd673b804f353504b8cca54b72e909ec0c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6b9b6e27c7a7cd28dc0bc45466f6803329111dbd845944f3964af32f8b339c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "07bb7aa0f55a35c96fe7299c72cb950448bddda251cdb209890dcf5cc33783ad"
    sha256 cellar: :any_skip_relocation, ventura:        "db709420c13a89ee10f4e4c0ca5cfc46ab472adda30c82963cd67b9ae72a5355"
    sha256 cellar: :any_skip_relocation, monterey:       "ba997ee1d63755681b50b8b0970643d829c38c81a465b23f68494a890aa6e182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43d13b8be379358c996c9d305ff8421f93dc2087f6c3113ec8222681db6eaf43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
