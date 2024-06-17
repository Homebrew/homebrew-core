class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.287.tar.gz"
  sha256 "fdc3fb57e8082bdabd3b35e2aaa8c237e7a131b45fe2be020d6582e49729c9de"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "234bb1a50884465b6551cb2d0cbe45ea82cc256a68502d6a3f4bf5f1640406b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cc9e47075860742203122fb235c5636c1c457eebb568ac7b97c67458383933d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b417a4c8959db5858a26427a5128ffb8fb3509705f313ceb48cd18e5c9e38563"
    sha256 cellar: :any_skip_relocation, sonoma:         "46c3da624d0f26bba44d658e1939d078db06c699410ec9ffd0fbacbabcc9f1e3"
    sha256 cellar: :any_skip_relocation, ventura:        "04ef9cbe9a15342f476bdccab638d75c6941abd93a86c5bbed93c3351620395c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0b22af3da3943051e081c63ed2156cd0588ae4af13e32d19c0f1fa8ee556a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6dc47cf374c604a6af7d685c6915b24f334208eac99b7b11f0ad11e5bbc115"
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
