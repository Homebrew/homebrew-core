class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.29.tar.gz"
  sha256 "f93e071d4924ab9fd10d5d7a61da802561ecacb42f5daf8079d8b52daa298882"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16272e901475ae8306615bd365d59424290bd377e78daefc7d9ba0039e5fd59e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efa4edffd097aa095d40b8b4bed72c3211bded73e120b2dc98e9dd63c7a7d6ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4325d2a07292d82dd406a842a2506d89c6edeceec7788de509fdc0438c815391"
    sha256 cellar: :any_skip_relocation, big_sur:        "30bb53f878b442e8ce40303960a0e1e7c6b0490f806ce705a4a58d650c909066"
    sha256 cellar: :any_skip_relocation, catalina:       "524a16cc39b53969b74970f4e66c434982179da05184f7396580ac184a78cdea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d32aff8b1160e98313b0d95b29596e6fd42f2b59c40826cc5bead44cd247c05"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "gperf" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
