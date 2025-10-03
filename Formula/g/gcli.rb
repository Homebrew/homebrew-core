class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "8dc15c917ee4442432dacdc226abc469e7e28a068fffc4d92c1c1ccbcc386658"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61e49986f4a05c2f350567c523198272a75ea193ea35ee7f1f0a43b37527828f"
    sha256 cellar: :any,                 arm64_sequoia: "ec6206908dcc72271e908e15bf83903772b2daafd26436684f9ba59b437f4298"
    sha256 cellar: :any,                 arm64_sonoma:  "7f23f53fbb12c73c5ad1749ab30c327459e6ed2100326993889ed1601d6348d4"
    sha256 cellar: :any,                 arm64_ventura: "3188b97d42c609ce2f1ce0756d9f032991168e38ff44ca2724d3011c03bcb9a9"
    sha256 cellar: :any,                 sonoma:        "56a29e14204ab8e5f5a9386cbdd5cda4aca9240b74d65a1a045822d9415b4dc9"
    sha256 cellar: :any,                 ventura:       "e9eb9b3886cc7e31b62c9bef9c233bc456e1a6da9775af8c95d1d1178243063e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6119b5ffb187b33e03a282e905c01883f5fa79905100671d33e332ab9ba97ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8174c05f29ea815d65eab6b10e1c65d5179b14bae06c3767d5070093dc62a9f4"
  end

  depends_on "pkgconf" => :build
  depends_on "readline" => :build
  depends_on "lowdown"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"

  def install
    # Do not use `*std_configure_args`, `./configure` script throws errors if unknown flag is passed
    system "./configure", "--prefix=#{prefix}", "--release"
    system "make", "install"
  end

  test do
    assert_match "gcli: error: no account specified or no default account configured",
      shell_output("#{bin}/gcli -t github repos 2>&1", 1)
    assert_match(/FORK\s+VISBLTY\s+DATE\s+FULLNAME/,
      shell_output("#{bin}/gcli -t github repos -o linus"))
  end
end
