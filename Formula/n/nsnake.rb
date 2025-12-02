class Nsnake < Formula
  desc "Classic snake game with textual interface"
  homepage "https://github.com/alexdantas/nSnake"
  url "https://downloads.sourceforge.net/project/nsnake/GNU-Linux/nsnake-3.0.1.tar.gz"
  sha256 "e0a39e0e188a6a8502cb9fc05de3fa83dd4d61072c5b93a182136d1bccd39bb9"
  license "GPL-3.0-or-later"
  head "https://github.com/alexdantas/nSnake.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1ede653161111adadc9dc28604dc24adf4ffba2657224e300c613c230d46bfc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d833e90080112061fbc54747bda14a5d5c1ac48bab003c62cbb9a2f1a71f1578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48a4e540caaa0e3c67718d4ee02c14473b0b498f2418e4f680b6c41e6b65e749"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08df400ffea570d1d05454d588e8e59717666bf169497c5fb2697d0ed0f240ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c212b9faab55968fd2a60490a7bf6df2ccb59aa78d677afb5296cec00a58d0c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb559f3a29d374cbaa1a96ca05671056e7a18f194e12e58fec21021d946ca74e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bce487c2e3125c1bbbb1dc95e6fd9b8ba3a2277eab080652a3ecffd3acab265"
    sha256 cellar: :any_skip_relocation, ventura:        "1fee1158f44144f5f1ffbdf356f28e945b35046caee5eae61b2f03603fa29dda"
    sha256 cellar: :any_skip_relocation, monterey:       "86696340da0ac35fc29e3295d9b5ce2f198c381a41adc796d45084e488207279"
    sha256 cellar: :any_skip_relocation, big_sur:        "22062984c8682ed418515bc558c03f8a2c477b4152c3abb1d486c404fdf8cadc"
    sha256 cellar: :any_skip_relocation, catalina:       "6ff26e57639f58e6bc2bbd36c511d3c21cf0b5e818b270efb6ae14e542c780c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a1660368200433643c2a044d0640a7ba9b485a6b8fd35093119b66b4c4a941f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bac278d384ea2b61e61c9baaf5b6bbbc388a520f5c39ca4978f8d2c60cdbede"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # No need for Linux desktop
    rm_r(share/"applications")
    rm_r(share/"icons")
    rm_r(share/"pixmaps")
  end

  test do
    assert_match "nsnake v#{version} ", shell_output("#{bin}/nsnake -v")
  end
end
