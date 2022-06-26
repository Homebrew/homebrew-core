class Lockrun < Formula
  desc "Run cron jobs with overrun protection"
  homepage "http://unixwiz.net/tools/lockrun.html"
  url "http://unixwiz.net/tools/lockrun.c"
  version "1.1.3"
  sha256 "cea2e1e64c57cb3bb9728242c2d30afeb528563e4d75b650e8acae319a2ec547"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64cb6e7d6280221f945c12e4489844d66757705911ff807932073c91a06e60fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c427c531d8c221639c456a7d57723bb8b1c832b4738b4173400988b5c9c54a"
    sha256 cellar: :any_skip_relocation, monterey:       "3aaf8d6393b298b453118399d2134c5833e32d3f22e21dda03cac778e10fa373"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c592ed7a2bef68c8e35b119bf3f3b60654461bbb15b59d6ed29e026c6298d2"
    sha256 cellar: :any_skip_relocation, catalina:       "8873fc021c96ed98f60c72b3a467aaa41f831c4c875e322efbb73343138ea829"
    sha256 cellar: :any_skip_relocation, mojave:         "0bacda6dd0fb9ab16f5a53191506132b338ce85e3367a0d150486a3c406ced5e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8e2764324f3709946ee1dc7b9c2135dca1e6c94b265d79fdb3f171809d88dfc4"
    sha256 cellar: :any_skip_relocation, sierra:         "5c37b3e9c3f55cfa50379c72fc00259bffa8d3d48688bcaaa44122805ffa4c3a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "10782346442c28b235f80579c1b0dac3ec784fb151f7bef475757c1bde944b16"
    sha256 cellar: :any_skip_relocation, yosemite:       "8f2914ed87c42a369b3870b5688720cf0cc7382ae6428452ba32fdf0e422ab57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f98a31a7651fbacfd1ccd1085b99fd53d1f4a5a981e4ed2702f2cbf1293126dc"
  end

  def install
    system ENV.cc, "lockrun.c", "-o", "lockrun"
    bin.install "lockrun"
  end

  test do
    system "#{bin}/lockrun", "--version"
  end
end
