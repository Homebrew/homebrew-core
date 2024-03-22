class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "31abcc1f12fc00078898d96bd32531cd3404a66147b40ab64b31c1d7027671f3"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5feec1f20d6bea906cea864f3b6e0d039dcbc18a2fd192d0bc3282789dc3d69c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f21a557798a53b0c544bbf1d226dd920b67656d7b092c5995e3396c993877216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0ef6a3f83c8166ffce3fbfd2952e0201321f0ef3f7b6f384d50514caf957a43"
    sha256 cellar: :any_skip_relocation, sonoma:         "a22664f35f2cdcb07c1175aab5897b833a8bcc141379d1b0dc269007607aecaa"
    sha256 cellar: :any_skip_relocation, ventura:        "55bf84bceb9e9f09bf12af1072e19f9a662a05edbbbe3393afdda7096738c9b8"
    sha256 cellar: :any_skip_relocation, monterey:       "4cbdb008eed488a7fed1777b606230c080577da45bb79cf43f2c325fd100a068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2feabdd0dec1bfa3187bad2d256c0f84bb93a8ced58aa2340021e7974b2a201"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
