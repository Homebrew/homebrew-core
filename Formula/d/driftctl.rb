class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  # website bug report, https://github.com/snyk/driftctl/issues/1700
  homepage "https://github.com/snyk/driftctl"
  url "https://github.com/snyk/driftctl/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "30781d35092dd1dd1b34f22e63e3130a062cf4a3f511f61be013a0ff2a0c7767"
  license "Apache-2.0"
  head "https://github.com/snyk/driftctl.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e4500350da7f07da19dcad11a5fbcd4459737a9bf2f3fcf7410ad8020a34c92e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d87de2f3a5e0374a88d7ea3cbdedd603f88a7567a230aa48812e9e0457555540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3ea52c1d74b676c7a9ead834f1d2d21515330c78b3a603361099b68f26184ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950108c93c9b3b586dd38225b9500c3567bb450c48c2167aa0f77065c69976ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f77e681d25b272b43d33ceffc3e267b96bb19e24849680ff8dcb655b9ee1194"
    sha256 cellar: :any_skip_relocation, sonoma:         "714af9730f7afe6a70eaea540001371f4e4ab5ff7968cde2ef07da4c31813865"
    sha256 cellar: :any_skip_relocation, ventura:        "8b9dfc0d29cf894157daea9ac173949a11dc37457b6ff829470cb664908b73f9"
    sha256 cellar: :any_skip_relocation, monterey:       "6ad20c81d5755fd801e386ffd8a4c9298970af04ddc32e3b68562a5288fc2576"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7515ca6fc4706faee61357732c04e3a51afe6b18f88c80cd7b8509ad6cc08919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87fead37c01350837835281119173d3ddd3d392f117bb03310a7b88f9f9a14a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"driftctl", "completion")
  end

  test do
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/driftctl version")
  end
end
