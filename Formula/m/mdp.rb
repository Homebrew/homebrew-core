class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/refs/tags/1.0.18.tar.gz"
  sha256 "36861161513c508c0589014510cdafd940a6e661e517022a3bea48ecf8d5fac4"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/visit1985/mdp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d9c1c94cdfa2dd2af19e510d4089aa35b38b0fe99e1b299e808efaaeed7d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918b9fa08b1a6e2d4f5f2f01347de2816daa19198fcdef894ffb1bd283cb78b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8000fac3c15c0a951865414a2d3d5baf2272c666c41b0db525f775292ad2e7a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4789d6eb27fd30580dbc27a65b176b21d013058874ab96b075fc6f7789a4c10"
    sha256 cellar: :any,                 arm64_linux:   "40b58e3f33661425349ee8936b6c42cfb2e34ff96fda71d7c751ef64f529635d"
    sha256 cellar: :any,                 x86_64_linux:  "fb0d4eac1050f9b09228c425bb9181ae99a5e72af24e81231d2d28fccbd10c08"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
