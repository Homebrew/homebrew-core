class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.5/lxd-6.5.tar.gz"
  sha256 "f5a0b8a4eb6cb259497bc5587c09d080193cc908a2696d54e071863d2a14c9cc"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d06355b126dff68e2014a16762efcbd44d3f4a1b7d9492e8080add9c213179bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272ef1c3d13fdd217f3487a7b8a04c433d1c235b35368f2cd1bdaa6bb5c2b42c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272ef1c3d13fdd217f3487a7b8a04c433d1c235b35368f2cd1bdaa6bb5c2b42c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "272ef1c3d13fdd217f3487a7b8a04c433d1c235b35368f2cd1bdaa6bb5c2b42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "223e9da8e5bde2990f42339fab52339235c39827a272a94993de3cb231bfef7e"
    sha256 cellar: :any_skip_relocation, ventura:       "223e9da8e5bde2990f42339fab52339235c39827a272a94993de3cb231bfef7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "366e9ba3bb1ab504f23ea30c8e22bf44a6b4cb7d594ced19a92065f4fb4e8229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0303be7c13e39c899429345dcde5dcef190ad7043d61ed9e993c46ee71775bec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
