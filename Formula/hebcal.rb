class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v.5.8.0.tar.gz"
  sha256 "dd710bead0162ee853078f4c5abfa696fb4076d0c1a41659612d77c554d30349"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0be2b41479110058201b536199ac41e4e122484f2647c344caeed295e6fc287"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0be2b41479110058201b536199ac41e4e122484f2647c344caeed295e6fc287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0be2b41479110058201b536199ac41e4e122484f2647c344caeed295e6fc287"
    sha256 cellar: :any_skip_relocation, ventura:        "20dc3b7c5cdade5a3a7685463c5d40b841f55e3aa0b08bf142a5ba9a3deb2372"
    sha256 cellar: :any_skip_relocation, monterey:       "20dc3b7c5cdade5a3a7685463c5d40b841f55e3aa0b08bf142a5ba9a3deb2372"
    sha256 cellar: :any_skip_relocation, big_sur:        "20dc3b7c5cdade5a3a7685463c5d40b841f55e3aa0b08bf142a5ba9a3deb2372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8161256ee94a9d41bf315b2394b44710039f7cc3524079c803c7591e1836492a"
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
