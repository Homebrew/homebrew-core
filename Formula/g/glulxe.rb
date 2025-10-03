class Glulxe < Formula
  desc "Portable VM like the Z-machine"
  homepage "https://www.eblong.com/zarf/glulx/"
  url "https://eblong.com/zarf/glulx/glulxe-061.tar.gz"
  version "0.6.1"
  sha256 "f81dc474d60d7d914fcde45844a4e1acafee50e13aebfcb563249cc56740769f"
  license "MIT"
  head "https://github.com/erkyrath/glulxe.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?glulxe[._-]v?\d+(?:\.\d+)*\.t[^>]+?>\s*Glulxe\s+v?(\d+(?:\.\d+)+)\s*</im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e50d971e530488c405300c86b204007beb91ded9fb87dc8936cfee6374075d24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bdc5dcc5eba9d4e5417b56c4cdee27958bd6ba76e5cecc60e46fff7aa4b754ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6605dc4b713cf75ff1e2082b4e515bbb3ec36dbb2846da6786538e1449fcef8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5559708d83a18e07bffde1b0c645a1efab90d28ea53b7d527d4a5c7b33601f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d08fff0e271fd5f05d5ef30215914fc7429e9b81f54255b7acea3f1350ddd29"
    sha256 cellar: :any_skip_relocation, sonoma:         "84c5aab0650e51fbc4fafcce2f61b6cb680b2e037ab3426ef4f1d3a4cf662f9e"
    sha256 cellar: :any_skip_relocation, ventura:        "bb4cd4317c7867a4ac3e41ad77a0d4aa84350aa7f356564e38fa8c1e3575c519"
    sha256 cellar: :any_skip_relocation, monterey:       "05f624354fa770cf82d75abf4f69e5f7d9a88962fa0e4e0416f55b65b2c46792"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8b77e80438457c50ca178ada89470fa378d266b3e18d2508e3a7a33268b01347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8af6c5daa098d3cd5b2878393f4b76efd773bf0d1be30ab2a8ed4fdfb84d38a7"
  end

  depends_on "glktermw" => :build

  uses_from_macos "ncurses"

  def install
    glk = Formula["glktermw"]
    inreplace "Makefile", "GLKINCLUDEDIR = ../cheapglk", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../cheapglk", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", "Make.cheapglk", "Make.#{glk.name}"
    inreplace "Makefile", "-DOS_MAC", "-DOS_UNIX -DUNIX_RAND_GETRANDOM" if OS.linux?

    system "make"
    bin.install "glulxe"
  end

  test do
    assert pipe_output("#{bin}/glulxe -v").start_with? "GlkTerm, library version"
  end
end
