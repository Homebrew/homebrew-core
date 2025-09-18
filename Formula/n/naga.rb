class Naga < Formula
  desc "Terminal implementation of the Snake game"
  homepage "https://github.com/anayjoshi/naga/"
  url "https://github.com/anayjoshi/naga/archive/refs/tags/naga-v1.0.tar.gz"
  sha256 "7f56b03b34e2756b9688e120831ef4f5932cd89b477ad8b70b5bcc7c32f2f3b3"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e2e548adf90a520aa549773229c0dfe0efd998f3c002d42f8816001ccc6d2cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ff5ae52821845aa9ac4bc84d74ec1554a08984c37767fc5facba882ff322f98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c49ba4967205f60079ad869d397bc75e1dd4130b86595dfd06a45836febccdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d32ce728cc5082fb81b509ee4d2aacdf3f3b3e5c99653493412afca4f4558559"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "060c060175d76dd77c768ec1fd07fe74fc01e404e4f4a6b8be3a75cead596abb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5598664fc7fd64d0f76d0291bbe79c209a65fd8142d6cbf7f7164531d538b9c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "61f379c8bd1babc088d64e3c1f64b6f480aff5f911e0b7619495614143a32f69"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a38c76c5088aab68b817aea8d249a40f2aec9101606494d42182826528561b"
    sha256 cellar: :any_skip_relocation, monterey:       "6b013d2185f67b684ab4f49db162fdb32bba2dc6914d9855c6f7fbb4bd5603f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "58d4a48fe33e676993449a2cdf332f74b6858681bc5519374d6e7a8842df9434"
    sha256 cellar: :any_skip_relocation, catalina:       "4a397ca0cf60725415818826e47fbf20c4b9cad2bc754128ece0d50279b715fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ff3c81dd29c36428f64d815f798bdb6c9a57aa7f73961c4eff5d5b08bd70cf07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ea8f618dc69a283560a3a51335c476824cee8bf5da7233620021e3c95f6fa7"
  end

  uses_from_macos "ncurses"

  conflicts_with "naga-cli", because: "both install `naga` binary"

  def install
    bin.mkpath
    system "make", "install", "INSTALL_PATH=#{bin}/naga"
  end

  test do
    assert_path_exists bin/"naga"
  end
end
