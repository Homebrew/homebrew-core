class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "65fac3b521fd94bc7a21585df7f8c75930beb1b62e6a1f8760333f51245161f5"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "123d1c4cb97930bc1af447704cfeb144614997bdee7f2d1591fd7f28f0c33bb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a7468ac17d8dc956b5408d171e5cab946d24796b3406e9506691a98bf679f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffd3a17e42218003a26e888f8dda387da27c5a951d82adfbf39152978eb2339c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5597ff2d6ecdb42fae33becc3915fbc12476a24c9991de77c15458ed10d56380"
    sha256 cellar: :any_skip_relocation, ventura:       "72bb2bed9ff731253664aaf19ad5e84c027c29ce628646956da4e8ace85ce0f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43d1700321ee65c312bbb5d879c9664ed04531445658a20225c4b28bb43a81ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6170214924d8ef5f9f22069d7442e36795430fd7901907a2e0597d348b03cd46"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository", output
    end
  end
end
