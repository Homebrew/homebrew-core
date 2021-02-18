class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://masterpassword.app/"
  url "https://masterpassword.app/mpw-2.7-cli-1-0-gd5959582.tar.gz"
  version "2.7-cli-1"
  sha256 "480206dfaad5d5a7d71fba235f1f3d9041e70b02a8c1d3dda8ecba1da39d3e96"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/MasterPassword/MasterPassword.git"

  # The first-party site doesn't seem to list version information, so it's
  # necessary to check the tags from the `head` repository instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+[._-]cli[._-]?\d+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "252fbad588409e4fd5be091f7c248150e75b995d39ce334938b9a7d33534cbc9"
    sha256 cellar: :any, big_sur:       "4ae85b3d30e47294436b7fddca456c98ed2bf546793f2ef9d57a372d782fb072"
    sha256 cellar: :any, catalina:      "2f275d762a9c73bd6b3f2e5a7f3f13a9c99ddfc3e2f89a2ededa07ba89b6de40"
    sha256 cellar: :any, mojave:        "9103716223529cd3e2cb969e904892bf2022cb8e73918418f2d3d343d1325c80"
    sha256 cellar: :any, high_sierra:   "07b89df8d96f9c1cebbf6296a4e98b2bac833c45f736b646a1eba24bd5244732"
  end

  depends_on "json-c"
  depends_on "libsodium"
  depends_on "ncurses"

  def install
    cd "cli" unless build.head?
    cd "platform-independent/c/cli" if build.head?

    ENV["targets"] = "mpw"
    ENV["mpw_json"] = "1"
    ENV["mpw_color"] = "1"

    system "./build"
    bin.install "mpw"
  end

  test do
    assert_equal "CefoTiciJuba7@",
      shell_output("#{bin}/mpw -Fnone -q -u 'test' -M 'test' 'test'").strip
  end
end
