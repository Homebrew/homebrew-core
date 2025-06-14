class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.8.0.tar.gz"
  sha256 "b89c68d7b933e0c281d51c9983a4837881db26dd1d5e7afbe958dd4666b3824d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66026bc84634ce360715bd8885626f10f8d59f370f55104d5a26c307bd2247cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357b7d3c69a3c56ba32674101622b7f4e4d1d3047849722034a65d4181aa27bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "510026b57d13197e12923095c0335c6b403092f5551796ccd76391f0adcfe5f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4135c7dcd3e10ef4815fb9dcef6f6821c1a7bdc78519f9b48be074849556df33"
    sha256 cellar: :any_skip_relocation, ventura:       "209174f76f0d1180ec60836f3f2f63ad7634e3f0a101498b0f777d4d2ddeab58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6112db8cf7e62f2e83bd000cb9f8a8a1da582e7843ba2388084b4e57c85939ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
