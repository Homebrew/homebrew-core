class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.4.2.tar.gz"
  sha256 "6dac98731942fa85ab827dc110ad3bd6e5de5f91be67ef5e85f6c3001d275e6d"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4326a6eea37cd292222c73ec119285e5cf98f222c6a4fd963096752bd9452d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4326a6eea37cd292222c73ec119285e5cf98f222c6a4fd963096752bd9452d86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4326a6eea37cd292222c73ec119285e5cf98f222c6a4fd963096752bd9452d86"
    sha256 cellar: :any_skip_relocation, monterey:       "caf7c355e0fcadac8e3f5dfd27cc813579543c4b701355f72d21c0fedb30cb3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "caf7c355e0fcadac8e3f5dfd27cc813579543c4b701355f72d21c0fedb30cb3f"
    sha256 cellar: :any_skip_relocation, catalina:       "caf7c355e0fcadac8e3f5dfd27cc813579543c4b701355f72d21c0fedb30cb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81263ae1645748534ff3690f45606ec63af8a728192c11bb8544eff676acc74"
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
