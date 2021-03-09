class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.5.1.tar.gz"
  sha256 "8421f4344dd11c1756e4041a678d5de32dae92eb01887d6ed147f5afc1e22675"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2678878106d0e49efc89fe54bc067baccfae665aebd315445fd2b209c92c340"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cb2093218ac5a1bdd37be8bca0e0d088d0634082f1140d8129a190d6fadb987"
    sha256 cellar: :any_skip_relocation, catalina:      "37410c79c87cf264f8fcaf7dc91aed79cc75a4c14217faf14e9a12b119c55bdb"
    sha256 cellar: :any_skip_relocation, mojave:        "4ed92b4233b11e2860096fde5f81ab350e76d535bf20ef2afbae3546edf8872d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: Not a Cargo project, aborting.", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
