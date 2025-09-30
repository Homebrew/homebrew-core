class Bbe < Formula
  desc "Sed-like editor for binary files"
  homepage "https://sourceforge.net/projects/bbe-/"
  url "https://downloads.sourceforge.net/project/bbe-/bbe/0.2.2/bbe-0.2.2.tar.gz"
  sha256 "baaeaf5775a6d9bceb594ea100c8f45a677a0a7d07529fa573ba0842226edddb"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8fd3005bedec280a143b22eb15bb126055e121ba0e1db118108c0878104263c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a207fd77fb072a948ca2261b0b2968e98932bea8c7afa112d310c6a6d9739d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da94323f0ee1b72c623dd63f3198dd8e25e0cb627277ff1bfeb9c81373441be5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1c7ca0dd8b2f4c9161de533964c1d783b3e09c9a108880d87236db9a7401eab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "095d439542aced7baf7f5994fe1d8ca64da82039222c1c083d09262cf559d4a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7181a956a065ea4b793431041e45cc04d217a7c64a579dcf1c7078249ee579ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "e82c72f757c617bc346b5702fe9333902e157042f4516acbb17d53164ecb5d16"
    sha256 cellar: :any_skip_relocation, ventura:        "81e9cc86f064e0e4a4b7dd44b6752a8f8643ba70dca6f08ae66dce92d4de58bd"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2799215e2d472a9ae04a451e486da0853b2861e3e9e04d274c8ba5e0c30f30"
    sha256 cellar: :any_skip_relocation, big_sur:        "677a07ce2e73761b8403033706a969d15bd89f98401054dccae350c0d9acdf6b"
    sha256 cellar: :any_skip_relocation, catalina:       "16ec8602703755894016b9ecd47ca9875a97c66ba259cdb8d7fa8902a17dd8d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "27f2ca2cf847bfde8d9ccba37c4678db988ac753755b97eec3da69f75092ba68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b683897c9241114a529a017dafad699e55a4bc3f19f1e3ef9bed408c8ee6c72f"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--disable-silent-rules", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bbe", "--version"
  end
end
