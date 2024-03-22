class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.8.5.tar.gz"
  sha256 "82624c9ddec1c85e439081ef3840427b27c90a96e2dc1b638ae7aec6deb8b88e"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04ada213d9b8dc8f29aed699ceacc267f58470cba6042b67b9ca5419f7068a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ada213d9b8dc8f29aed699ceacc267f58470cba6042b67b9ca5419f7068a26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04ada213d9b8dc8f29aed699ceacc267f58470cba6042b67b9ca5419f7068a26"
    sha256 cellar: :any_skip_relocation, sonoma:         "643e035bd8807541dafa733835b9657d706f14fe4e0c9335f843e2bbd508973e"
    sha256 cellar: :any_skip_relocation, ventura:        "643e035bd8807541dafa733835b9657d706f14fe4e0c9335f843e2bbd508973e"
    sha256 cellar: :any_skip_relocation, monterey:       "643e035bd8807541dafa733835b9657d706f14fe4e0c9335f843e2bbd508973e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1626cc3eacc7d8cc4174b9d1e72df0ea1113a0bf57d7b6e1a49de04673c015"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
