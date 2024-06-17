class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "286b1b1409f55950ded8e02fdea4ef0f1a5d27f552c04ec70bd52fdfa7a94cee"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e45eeaab0b0855dfad5a03c85e3c35d2fb25fcbd763e09c87e90883849e9a5b2"
    sha256 cellar: :any,                 arm64_ventura:  "b2b67f7ac2a2047fbd57bff2c5dc2bcc33f48ba6111bb858eaf9bb6778b28062"
    sha256 cellar: :any,                 arm64_monterey: "4570148e5715a6b4c2815cb2a245d565acbd83793452529d7cd64d5181f31c7c"
    sha256 cellar: :any,                 sonoma:         "4d1e194e8ef87eebdcc41e5440a9f695358b8b1986ae166fc5a053674fc310b7"
    sha256 cellar: :any,                 ventura:        "a707d35748e513acf31c62466fc715c358cbfea77eddf38f42d11f845a18d753"
    sha256 cellar: :any,                 monterey:       "18377c830560827726ad46a325616b27b9820a56f6c1e114082cbae9efd5c6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39904d58aecb51a459876858d1c7a63314945c4e73186ceaf733426232b6242d"
  end

  depends_on "go" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libcanberra"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # dissent is a GUI application
    system bin/"dissent", "--help"
  end
end
