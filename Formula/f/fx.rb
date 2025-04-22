class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/35.0.0.tar.gz"
  sha256 "5ab642bb91ad9c1948de1add2d62acec22d82398e420957c191c1549999eb351"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8222f75e23b7eb70afe08accc15e5e47edb4fb2a7f292783c3e519860334ea6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8222f75e23b7eb70afe08accc15e5e47edb4fb2a7f292783c3e519860334ea6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8222f75e23b7eb70afe08accc15e5e47edb4fb2a7f292783c3e519860334ea6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9415000df5544c72bd65cc45416747ab76b065ea72619f9e8e5de6bf9e189cc3"
    sha256 cellar: :any_skip_relocation, ventura:       "9415000df5544c72bd65cc45416747ab76b065ea72619f9e8e5de6bf9e189cc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b9cbf3db820e33f2f832e836a193d4e5af804a53fb84961e97ebfa05562623f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3499b53ebeaf36e154444504aaa4659576c5248921fb1b3ac1e6212de1aa48"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
