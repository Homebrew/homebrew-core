class Certgraph < Formula
  desc "Crawl the graph of certificate Alternate Names"
  homepage "https://github.com/lanrat/certgraph"
  url "https://github.com/lanrat/certgraph/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "233b6bf6c081d88c63ed26b2d11d09a74e55f3dfc860823fdf946dc455a1d135"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/lanrat/certgraph.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61e0de8d4c9914e75649461e35b23e1e698bfb56e2870bc9e0d34e9169d5857f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df3eb13c0ca4209724b54ee672565073bc8cecea87b3f4819bba9d878c82fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df3eb13c0ca4209724b54ee672565073bc8cecea87b3f4819bba9d878c82fb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5df3eb13c0ca4209724b54ee672565073bc8cecea87b3f4819bba9d878c82fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4141330eed9a89e2b7ae519914a527f90ae919796a14ed641dfae691bc643f50"
    sha256 cellar: :any_skip_relocation, ventura:       "4141330eed9a89e2b7ae519914a527f90ae919796a14ed641dfae691bc643f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1491f25410592de4a87b0681981015401a7456c8d618b7ddcfc6afcdb51c41d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac679b05635a7ad66dc2a1e5fbcfaa8cb536b9fa2b24b569704fb306ecc3673f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/certgraph github.io")
    assert_match "githubusercontent.com", output
    assert_match "pages.github.com", output

    assert_match version.to_s, shell_output("#{bin}/certgraph --version")
  end
end
