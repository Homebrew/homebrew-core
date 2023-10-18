class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "131c35bd31996d9545521f4c604fea8955ce1865e7ab58313faa786e79f3b034"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f927236aea7e75a35511eba6efbe079005d6ff75a75ffc3f92416a02cbaa9b1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e953bfd451e66d9f1ff5896e5d948988c322e14710a2d2ba8ee3bd229c265cf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e953bfd451e66d9f1ff5896e5d948988c322e14710a2d2ba8ee3bd229c265cf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e953bfd451e66d9f1ff5896e5d948988c322e14710a2d2ba8ee3bd229c265cf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "667c64324aa8549b8917b8cb9d7ff0c29710afbfaae820f2f71fd54127714525"
    sha256 cellar: :any_skip_relocation, ventura:        "6c53c36c04129e14550a5cebd1eb078ed8f82a8543c375dc72fce79acd296de8"
    sha256 cellar: :any_skip_relocation, monterey:       "6c53c36c04129e14550a5cebd1eb078ed8f82a8543c375dc72fce79acd296de8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c53c36c04129e14550a5cebd1eb078ed8f82a8543c375dc72fce79acd296de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07910611c4242bbf7c97ec11299f369f64adff137206bce52fda6e669df48202"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
