class Lockrun < Formula
  desc "Run cron jobs with overrun protection"
  homepage "http://unixwiz.net/tools/lockrun.html"
  url "http://unixwiz.net/tools/lockrun.c"
  version "1.1.3"
  sha256 "cea2e1e64c57cb3bb9728242c2d30afeb528563e4d75b650e8acae319a2ec547"
  license :public_domain

  # The upstream website doesn't publish version information, so we check the
  # version history comment in `lockrun.c` itself.
  livecheck do
    url :stable
    regex(%r{v?(\d+(?:\.\d+)+)\s+\d{4}[/-]\d{2}[/-]\d{2}}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4fb5751401d9a0c9e2cb5abef0124aa4fa8ed867591b6055fdb52455452b6389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fa9f904cbb5c509a1aeef7afb173599b212352054380f017c9ff657a90aa866c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60567111dd2a82dc49b2c4687b16cf29a21543d68f533e2ec8b34e4f1da2bd77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faddfa34e58f779eb9881ab52b8623f41a875b6198a40a6588e7048c42d210a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64cb6e7d6280221f945c12e4489844d66757705911ff807932073c91a06e60fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c427c531d8c221639c456a7d57723bb8b1c832b4738b4173400988b5c9c54a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dcc0b0790ef1ff21ab7cf7e17273007c575335c4c954265a6c3d98fc732f621"
    sha256 cellar: :any_skip_relocation, ventura:        "f6898ae5b1113480d59d39f49709a50759290b7ac0ce53545cf9d63cbf602d45"
    sha256 cellar: :any_skip_relocation, monterey:       "3aaf8d6393b298b453118399d2134c5833e32d3f22e21dda03cac778e10fa373"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c592ed7a2bef68c8e35b119bf3f3b60654461bbb15b59d6ed29e026c6298d2"
    sha256 cellar: :any_skip_relocation, catalina:       "8873fc021c96ed98f60c72b3a467aaa41f831c4c875e322efbb73343138ea829"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "141fc5e4c50953b8ed382b7c3cee817d578808ccaed0c72e00d7fc3c0eda8942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f98a31a7651fbacfd1ccd1085b99fd53d1f4a5a981e4ed2702f2cbf1293126dc"
  end

  def install
    system ENV.cc, "lockrun.c", "-o", "lockrun"
    bin.install "lockrun"
  end

  test do
    system bin/"lockrun", "--version"
  end
end
