class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.41.0.tar.xz"
  sha256 "e748bafd424cfe80b212cbc6f1bbccc3a47d4862fb1eb7988877750478568040"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70af16d8adb36f6a94c2e3908de9b513d2e11d90c86e2e2542cfb09302668fb0"
    sha256 cellar: :any,                 arm64_monterey: "6724f5bb76c5c8f9eea6a8d9d60952e4226df1dfaa8d9918746702dce52923ac"
    sha256 cellar: :any,                 arm64_big_sur:  "b839056189a686ca9321430086bbcb5380dda89e920b20cc1772b4bd7c28b68d"
    sha256 cellar: :any,                 ventura:        "040a744b24a322e9caff9d5b50596b538afb1bee86ee58c8784b81b8a1816fcf"
    sha256 cellar: :any,                 monterey:       "51b17f54c0ed184188d21fad5fabd06183bbff3686f9c5f9407c4be5f4a8479d"
    sha256 cellar: :any,                 big_sur:        "6148fe2749fe017b6ca4d2fb961bf7c18cbc36bfebedc9a48aef103749b7495e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc5fc049d69689c2d1d4a0b9171bdacd37023cb316c4fe847582fda22e108ab6"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
