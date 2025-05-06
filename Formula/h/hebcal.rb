class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "236617ad37c7621e61eb4aa10e407cf95950563bf5e0c663e4720e5a9fb5e3dd"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29b4c545ce82fdd87512f859b1377b3cae30a6cd092ba1a5be4c6cec6fb7a868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29b4c545ce82fdd87512f859b1377b3cae30a6cd092ba1a5be4c6cec6fb7a868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29b4c545ce82fdd87512f859b1377b3cae30a6cd092ba1a5be4c6cec6fb7a868"
    sha256 cellar: :any_skip_relocation, sonoma:        "641185644af7b9ccf87fe96cb9be7261a67a51b07e45712c27be7f881a43f917"
    sha256 cellar: :any_skip_relocation, ventura:       "641185644af7b9ccf87fe96cb9be7261a67a51b07e45712c27be7f881a43f917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d7f436d8dc946674c8c4dc35eae6148b094976c481762d50112b65cae9d46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ce8d3960251c1e1813b16b5f559d08bed22e5749a205c850d0d281033eee72"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
