class Amy < Formula
  desc "Nostr client from the Amethyst project"
  homepage "https://github.com/vitorpamplona/amethyst"
  url "https://github.com/vitorpamplona/amethyst/releases/download/v1.16.0/amy-1.16.0-jvm.tar.gz"
  sha256 "ecf95078146669c50e5fae179e8cc40ed4a387df299027f6b39faf95b3ed3f79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0a15b60bc42c746bab96af35140b19a9d14638c7984ff4d833e77e829f720200"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"amy").write_env_script libexec/"bin/amy", Language::Java.overridable_java_home_env
  end

  test do
    require "json"

    # NIP-19 bech32: a known key round-trips from hex to npub and back.
    hex = "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
    npub = "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyjh6w6"
    assert_match npub, shell_output("#{bin}/amy encode npub #{hex}")
    assert_equal hex, JSON.parse(shell_output("#{bin}/amy --json decode #{npub}"))["pubkey"]

    # secp256k1: the public key derived from a freshly minted secret key
    # matches the one minted alongside it.
    generated = JSON.parse(shell_output("#{bin}/amy --json key generate"))
    derived = JSON.parse(shell_output("#{bin}/amy --json key public #{generated["nsec"]}"))
    assert_equal generated["npub"], derived["npub"]
  end
end
