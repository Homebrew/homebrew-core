class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://hebcal.github.io/"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.17.0.tar.gz"
  sha256 "bee68122bc38f0cdc98bc0001dec4101cf11f78226bf061783c1f5ddf9d52a54"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0e5a378a686b38642748e07d926908836e7342138731be3004ddec40264781f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0e5a378a686b38642748e07d926908836e7342138731be3004ddec40264781f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0e5a378a686b38642748e07d926908836e7342138731be3004ddec40264781f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d9d7b097a7c03886e591be441ad7a1d2413c76c14792c0ed4e1a66f77c82363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "db046f96d9ffdec02129531907cdc34875de14193f3d7ca1df671e7e9d6da21f"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
