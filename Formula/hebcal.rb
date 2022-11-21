class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.4.1.tar.gz"
  sha256 "c5cf3b83d60128a7e6a4de570ed3e755a9beeb6b2e31d646dc001871d113bac0"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9aaf8c5c17532e984c1c4014bf142728c23f6e19381b238d7ef801d63960f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9aaf8c5c17532e984c1c4014bf142728c23f6e19381b238d7ef801d63960f5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9aaf8c5c17532e984c1c4014bf142728c23f6e19381b238d7ef801d63960f5b"
    sha256 cellar: :any_skip_relocation, monterey:       "962632b0e9a2bbcf8fa8d7303f39fee64e71590f4685221aa980d173601ae368"
    sha256 cellar: :any_skip_relocation, big_sur:        "962632b0e9a2bbcf8fa8d7303f39fee64e71590f4685221aa980d173601ae368"
    sha256 cellar: :any_skip_relocation, catalina:       "962632b0e9a2bbcf8fa8d7303f39fee64e71590f4685221aa980d173601ae368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ad9df63f0e2b7b3b7e1a2da4798e922ce00731bbf8f563c7f2bc208360e3a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
