class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.21.tar.gz"
  sha256 "ab8d90f28946289ef07abedcafc8dee31b0b428aa06a6c8bca3f4b7c3e9ca963"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c0326be9d95bf9723834f2be183098bd0bb2f9eeabb1768c0c5b9185952b5d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef886561a78f36e16d051d6645fbf39e7662854fe89755e130fe9c4dc1a84c34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9606490bab110f8f7a1fcd883012c5728d15f71581ffe76d76d2ca068c4a955e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ffb2a8ccde837a56b4fb223b344874b54edb0838f10a9adbf494da432297aa"
    sha256 cellar: :any_skip_relocation, ventura:       "318e82e41a58cf57c7b93dd136232b7921fb6a075112c993e057ee0f0abee6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb57c453eae78821c94630f7eaf08c396353280c627a6fb190195e425b4c959"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
