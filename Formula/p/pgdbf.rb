class Pgdbf < Formula
  desc "Converter of XBase/FoxPro tables to PostgreSQL"
  homepage "https://github.com/kstrauser/pgdbf"
  url "https://downloads.sourceforge.net/project/pgdbf/pgdbf/0.6.2/pgdbf-0.6.2.tar.xz"
  sha256 "e46f75e9ac5f500bd12c4542b215ea09f4ebee638d41dcfd642be8e9769aa324"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "be260fe3bed2656f7950f0715feee61893dc672cd737a1752896310c70b44b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a1747cf572e94ce2d46311dc5f7d13f736e22f0b1be93a3abd0fb8e1c3d781ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35cd208c6ab173a31b1732a64b19ae4a9f34d127ec6dbfed163452e5227c6e50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2ecba3b5b9e4803f45f71afbaf66d85333ec329f74513123dbfdc9822b803c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2743386480c1d76708d184813b77daadec3bc7a70a542647308c9fb414aa65e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b51760692708d6b3926a405f7b2e83553feeea062a1af91aa0b15858cf9e8b8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f559d2b12a26f57eb903013af9eee09b149a447ef49249007e1973a9932c8255"
    sha256 cellar: :any_skip_relocation, ventura:        "30721323815b2ff787ea33a99a3a693e126eb4f3222c447a59c8b10d3fa677ba"
    sha256 cellar: :any_skip_relocation, monterey:       "6381607bca777a7beb5d475f656a949e580e82b15d1f63fa109764c652da5d9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "efd6ad07c77d7c973b9d4bd8e13ea837b43ac281c817f3ce300ac6c46de3f2e4"
    sha256 cellar: :any_skip_relocation, catalina:       "ae8050a5d6a6f91f529a0985a5626981d22573094791274c7bc1759b2770c4c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6ae4511e609fa6ac9a2b0566969f0e511756b9e6b6c55f17655333aa7ddd01a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f2e231fc1b78b7837dfe257a04e2495128237e5800609675573dd2734185ea5"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
