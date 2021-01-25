class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20210109.tgz"
  sha256 "c416c987bf77b4f1b2703d7c5e433ba9458c8be5266bf454cbf801ad87e72936"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9803485a0a9bc47cccc0f33b094118a4f90fa38273ae5f7b4d9b192f43d3c038" => :big_sur
    sha256 "7dd0481393a5fc27b44df7ee3df3f54003a6740c4d7e0a8aaee2aa7758688754" => :arm64_big_sur
    sha256 "6bf69e8c6bcd620b0819d36279685682309dfed28a6e6fef450d1303ca3f28ce" => :catalina
    sha256 "c42a077663368d0a0ee0dfea749a4981d3ed093bdd86bafc50204999b9e0c756" => :mojave
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
