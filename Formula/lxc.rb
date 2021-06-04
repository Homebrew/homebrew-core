class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.15.tar.gz"
  sha256 "5178a918d59c9412a0af4af4c1abfce469e1a76497913bc316bf602895a2b265"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c89df746a069cd2fee3a0100827536fecd272508ce1e1e608a693c164b4ec02"
    sha256 cellar: :any_skip_relocation, big_sur:       "52bf281ff8c4d8ac221df798cecfd85f99bffcf76c546a9d1f44518abfe52388"
    sha256 cellar: :any_skip_relocation, catalina:      "e369d0085e38262e363d6d924571a32a01a175236ff9b365be594fe0b6f9af13"
    sha256 cellar: :any_skip_relocation, mojave:        "26ab120b923dad16975efeb53507598f4573edc7f07d61d52d6d2c6e1306cbd6"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "auto"

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
