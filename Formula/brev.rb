class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.211.tar.gz"
  sha256 "960f39067c4631cbcfc71b950fe74650e778f74c5d044f695e6ae58b4571ec32"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "170e927911edce4926d6fb8a14530622d1b601a6ac2ee7527311cbdec5345978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c062cebcbbbfc6262ce8c39dc4836015759dfd4a8eed41d64ec68a69ae3f7456"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b35bf244506cb51f6e2417d5857801efb46ae8d248655df1bcb659554bfcd6a"
    sha256 cellar: :any_skip_relocation, ventura:        "3bd71f0a1a8df1e732065a4c0e88a6db722b0783907ebf66f1dea1b2a309039d"
    sha256 cellar: :any_skip_relocation, monterey:       "c4082ce143840441c89d23d82a81fdb71cf8318898816e64bb2104a985dffeeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5f1e207e7dbe2965201eeb75f6d864a00049c4bebe2affdc9321328f9b87003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02131e98a27c0cc549fa4b18ae8bcdcee9f46580cf5e5ea4601642630eaf9e60"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
