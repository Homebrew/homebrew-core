class Nsnake < Formula
  desc "Classic snake game with textual interface"
  homepage "https://github.com/alexdantas/nSnake"
  url "https://downloads.sourceforge.net/project/nsnake/GNU-Linux/nsnake-3.0.1.tar.gz"
  sha256 "e0a39e0e188a6a8502cb9fc05de3fa83dd4d61072c5b93a182136d1bccd39bb9"
  license "GPL-3.0"
  head "https://github.com/alexdantas/nSnake.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08df400ffea570d1d05454d588e8e59717666bf169497c5fb2697d0ed0f240ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c212b9faab55968fd2a60490a7bf6df2ccb59aa78d677afb5296cec00a58d0c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb559f3a29d374cbaa1a96ca05671056e7a18f194e12e58fec21021d946ca74e"
    sha256 cellar: :any_skip_relocation, ventura:        "1fee1158f44144f5f1ffbdf356f28e945b35046caee5eae61b2f03603fa29dda"
    sha256 cellar: :any_skip_relocation, monterey:       "86696340da0ac35fc29e3295d9b5ce2f198c381a41adc796d45084e488207279"
    sha256 cellar: :any_skip_relocation, big_sur:        "22062984c8682ed418515bc558c03f8a2c477b4152c3abb1d486c404fdf8cadc"
    sha256 cellar: :any_skip_relocation, catalina:       "6ff26e57639f58e6bc2bbd36c511d3c21cf0b5e818b270efb6ae14e542c780c0"
    sha256 cellar: :any_skip_relocation, mojave:         "195e486eb84a9fa230bfa31558d6b3fb8ae6715ab444f3aead9c997a43f981d8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5f8de3bf4148a6d9fdb32b5584e4aa5890c8f373ad5be36b17473e4d7c2f0a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bac278d384ea2b61e61c9baaf5b6bbbc388a520f5c39ca4978f8d2c60cdbede"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # No need for Linux desktop
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"pixmaps").rmtree
  end

  test do
    assert_match "nsnake v#{version} ", shell_output("#{bin}/nsnake -v")
  end
end
