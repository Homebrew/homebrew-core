class Mp3val < Formula
  desc "Program for MPEG audio stream validation"
  homepage "https://mp3val.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mp3val/mp3val/mp3val%200.1.8/mp3val-0.1.8-src.tar.gz"
  sha256 "95a16efe3c352bb31d23d68ee5cb8bb8ebd9868d3dcf0d84c96864f80c31c39f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e5c10f2c40b3db42ee31ebdff666e1f56da1b200829945556f269cc1be920c64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef2fd722be9a2d08c7d180ed19f6be46bc2944392f996b607ecacdd10ef1b0b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e063b1b72dc1265814eeac66793a4778a389aa0d0b5eaf1fe459e934195f8c6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d055d4fb5b3abc7ded7ad8e99011fc2e84cf0d8c24c01f1512941b17d3f02d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d5718fcb9967416eb3e3cf3e9a186e98bade6be099c57583b0d9dcc0fa43103"
    sha256 cellar: :any_skip_relocation, sonoma:         "15fc504bc8eac0681a75c0dee18eb114313d8393b11bc3ab412d68240fa51cc1"
    sha256 cellar: :any_skip_relocation, ventura:        "2e853ffc3b232162f4efc76f4b166684f7433dbb0548ed424154527ae81b4289"
    sha256 cellar: :any_skip_relocation, monterey:       "981e3b3fbb87bd417e50d947bb994049508ce850ffd432c9d3ae0306cf3e6182"
    sha256 cellar: :any_skip_relocation, big_sur:        "671ef59185d212e89c19dda72da09ef7a37e3055f4d42d188079f29122c641dc"
    sha256 cellar: :any_skip_relocation, catalina:       "c08b493f2f59730486c427b795112ea1c730fb9bb7dcbc0bc9158c2c28a30c51"
    sha256 cellar: :any_skip_relocation, mojave:         "4ca5fe184a5427aea0df6910d654955c162268f803c1c372d11dd2305ad67513"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f17a5c03d59e7665d2b85db559561a3375ff03a6e02911514a0adde35e188a06"
    sha256 cellar: :any_skip_relocation, sierra:         "649cf78ba7bc387f346a6685b8c83bec495a5e75ea0fa6d93135cc36ec898f5f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d13a9b31c885d1704a0cc5e1ff6b995acd616248abcf5276fc068b78f7be785f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "83bae7eb1335d4f48f940a32c11d5e4e62fe48a4485a2d727456c6def98af8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36cb11d26af2abdb0e0d811bb91f24d9b7e78bfdd8cd65f0aa2283c08725feb"
  end

  def install
    # Apply this upstream commit to fix build on Linux:
    # https://sourceforge.net/p/mp3val/subversion/95/
    # Remove with next release.
    inreplace "crossapi.cpp",
              "od=open(szNewName,O_WRONLY|O_CREAT|O_TRUNC);",
              "od=open(szNewName,O_WRONLY|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);"
    system "make", "-f", "Makefile.gcc"
    bin.install "mp3val.exe" => "mp3val"
  end

  test do
    mp3 = test_fixtures("test.mp3")
    assert_match(/Done!$/, shell_output("#{bin}/mp3val -f #{mp3}"))
  end
end
