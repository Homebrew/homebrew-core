class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.279.tar.gz"
  sha256 "49113e04430164f1828700b2d56aca60aba2d63d863fed8827096e007661fb29"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e3b7d7485a71d72979e2187715f17f5d6386521b95d1392e947f286ad36a6e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "334e01ae605e3428e1c2ae2bf0a9568eaced387e5bcaee84e6cbefeb540275f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e80374e3fdb0931307ce8c3998ceaf2d53d3924f13563e615c472e462dccd91b"
    sha256 cellar: :any_skip_relocation, sonoma:         "883eac9dadfd06e4e8a92c942d8eae70e9e33e20f637a7644d68ef213905c63f"
    sha256 cellar: :any_skip_relocation, ventura:        "de6a662652c04a9142885017131232c12b74a5d992d82bafdca5ddb59b79a389"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a47c5843c2b648b73684003f103245e398d814988f2230624fb275fcdbf0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cebbde3f99b371523bffc834ea6ade5df5159398a29ffa63a4b9751098f2d86"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
