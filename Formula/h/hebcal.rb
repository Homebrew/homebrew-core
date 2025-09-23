class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.4.tar.gz"
  sha256 "65ed5a00a80e17acbcb5ab1541dded0170ee5188e3cc34848b69a94d14ec12ef"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8a92ca04c74a873532776fff1f32d6c21ffb033a149e2e5b2488683f61c886b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "068663f85deb551bc6a8b41b3457c6169c295c91b32fe2f34ffe32afc15ff41d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "068663f85deb551bc6a8b41b3457c6169c295c91b32fe2f34ffe32afc15ff41d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "068663f85deb551bc6a8b41b3457c6169c295c91b32fe2f34ffe32afc15ff41d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab9ccd575666fc2ef58692d5ffcd6cd23827001e7ff1618dda6127a1c480e4ec"
    sha256 cellar: :any_skip_relocation, ventura:       "ab9ccd575666fc2ef58692d5ffcd6cd23827001e7ff1618dda6127a1c480e4ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4811b7059d3d72fd96e9edfb2e4d50e2752a7d764ec7b19e15f3ae5aa7f2fffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7bbefb0d13d57a312daa618d2c485351e365e779025e236a4893c4616a02365"
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
