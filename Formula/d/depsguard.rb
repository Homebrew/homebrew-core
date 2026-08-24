class Depsguard < Formula
  desc "Harden package manager configs against supply chain attacks"
  homepage "https://depsguard.com"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "0db158f447f8ebf887466ae57f0d7bf6f02c8d647fa02235d3ebb5852a395193"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2023a696971b4e33163ccbca50feff2db9d235fc1d7effacc4efc09491e79c0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d084cd22f7a0609625f9a065c33c995178535368db8b9da54ec6531125fe5ceb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eb9ac73052070de8922d6579d09eff01143121c002f39a0899341ebc646575d"
    sha256 cellar: :any_skip_relocation, sonoma:        "13bcd49a1df05abd1926ef62f3368613a6f51a566560534f07498783feb44a7b"
    sha256 cellar: :any,                 arm64_linux:   "40d764c1061365f5d8ede87117ab63a22fdcb4c4b94913e5baddd91101586bf9"
    sha256 cellar: :any,                 x86_64_linux:  "14681dc85f2cf4cdb02f7ae5b079eb186b9fd9fe46d3220d883389f7c3a5c623"
  end

  depends_on "rust" => :build

  deny_network_access!

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depsguard --version")

    # With no package manager configs present, scanning the current directory
    # finds nothing to harden and exits successfully.
    system bin/"depsguard", "scan", "--no-search"
  end
end
