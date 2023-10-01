class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.9.2.tar.gz"
  sha256 "2eec1319f1bc7f1a5f28c6451bc655cdcab64327b98c345ea20ff4ac6fc5d0f2"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbba29bc3299286063537aa78c0de38e06b430945b97f0dc51c070db2b50bccb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df0d743e889c90b8aeec583747bc54b3ab60ed63bf6628f5182d9517b7471611"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d4ce91db857546aadf29c60311906b737acfbaf406bd2898ca6cbaf5082c0a3"
    sha256 cellar: :any_skip_relocation, ventura:        "fa305c96c087e5672862c176414fa1c24f48f560e6641ce2ae341c0d59438d17"
    sha256 cellar: :any_skip_relocation, monterey:       "7743cb69bb35a763352fcb7db352401af88d7ce581756a3e23cffb8a15650bc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7908384141d9c2c9f48850334272550be25b98cbda6a95fc7fb82218afc0294c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeda076799c39f886b13c302c3aeb8684dad4d684f7888c7026bb6600b40d8b6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
