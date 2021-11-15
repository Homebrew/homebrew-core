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
    sha256 cellar: :any,                 arm64_monterey: "e9888d9cfb2d36d1b764cb66f63f6dd46007a1971a4103207cb443029c1d12ee"
    sha256 cellar: :any,                 arm64_big_sur:  "ae3c6d9c4698beed61f7d0ee6330d1afa63b993c8ff3ecd3dae5fea25dc052be"
    sha256 cellar: :any,                 monterey:       "9bee356778557f9ebe1ef53d3c30eea3484593de4a5465a9edda5d1bda03524e"
    sha256 cellar: :any,                 big_sur:        "ab5d2d32aee8f5d90e3818a776d10a681ce84435161ef9a9c146310b2277ce93"
    sha256 cellar: :any,                 catalina:       "577e79323642d34b2ab391959ce2075e96172faa540c2e9d628406d0e80e2fc4"
    sha256 cellar: :any,                 mojave:         "8592cadcded1acf97d687135d7f9f88674c05837e6f9646bb514c0b7fc18c954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aaf191d28ba5c097800350caa11f37f351f8f0ff336aed7f0e479d884321e86"
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
