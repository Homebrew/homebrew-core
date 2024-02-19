class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.273.tar.gz"
  sha256 "cb61176df1952347de2b5afcc06db5edb8deeb15cb3c8f9402022ee5eb06b2ad"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15b44998b06679bff9a356626d3af9dd72d4c78a1db4f018d5c7e14a0c31755e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d5098e19e00ad18322a596c50225937523e7fe86cbed69ad311d83a4bb524ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0dc1c59ad48675154d5106f6de9da5f5a168927f7337085297c6256501c1887"
    sha256 cellar: :any_skip_relocation, sonoma:         "72eed49df0bf5d6ac46de92a423465bb1bc8a41733c429f6b109f1786d637ed4"
    sha256 cellar: :any_skip_relocation, ventura:        "df6a04a2241a1e08336d7992224d1156313ae5db7277363818cea730a3fb2ca1"
    sha256 cellar: :any_skip_relocation, monterey:       "6d69fab844e0c8f3d3d74631c9e800763116af4fafdc7725d685886052004885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19107a231c0b530797a5ccbb4f23f1ea75a915ceb962b2f1f76302ff76f22ad"
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
