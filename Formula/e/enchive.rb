class Enchive < Formula
  desc "Encrypted personal archives"
  homepage "https://github.com/skeeto/enchive"
  url "https://github.com/skeeto/enchive/releases/download/3.5/enchive-3.5.tar.xz"
  sha256 "cb867961149116443a85d3a64ef5963e3c399bdd377b326669bb566a3453bd06"
  license "Unlicense"
  head "https://github.com/skeeto/enchive.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a0c663f95e9a509534933df146b2ca6792ce0388907cc07b8eaffb3025ed139f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e5167a67337419271ca6275a8ee178da5c3b417dd29721ed7c954c2cecaa8dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea632e41797ea8ac720c8e0ded7eafe6b580fecb092bbe0d25e0c2a805189a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4031f7e6516988ab5a83c2e1b9f88af552d71575772348383860a6015fe121b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfc24708c8b6d000fc36f7d2fd305af3ad5a1f3718e0d0c92cf122e140866e57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "653b17e2b34133e5cbbff75e3df94c251c92f043a0d2af28719ffbccf2835efa"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c5cd5ffdc8e1849860c173711a5ab29f356b452d86efaf944dca480afe70963"
    sha256 cellar: :any_skip_relocation, ventura:        "6e1fe9e5471985e9d9caadc563297313ff0d0e15a8aa1ac3ccb15be45ec4879f"
    sha256 cellar: :any_skip_relocation, monterey:       "abca74b9d636453d9612bd0a89f2256684dc3ed42aa72bf8fdb2fcfc84788819"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3844247a43c518b50f8a33847a39e5c91db46fdd177b810ac9d2776b842ed7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9f0cbe65f702629660b17db25d09bb215a4383d569b781251cabb82acb5de040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116e7fa59dc5c555ef911ca1668175cb71fce934dcc3f475433e84ce6d2f4d14"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    sec_key = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00" \
              "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
              "\x78\x06\x15\x09\xf7\x1f\xc4\x68\x95\x3e\xd4\xef\xfc\x22\x2f\x42" \
              "\xf3\x2b\x2f\x2b\x85\x2c\x71\x0b\x96\x80\x93\x70\xfb\xdd\x32\x71"
    pub_key = "\x8c\xb7\xc8\xf0\x2c\xec\xa6\xf4\x63\xbc\xde\xd1\x92\xb5\x72\xae" \
              "\x58\x58\xe5\x13\x3f\x6f\x60\x77\xbb\xe7\xa3\xe0\xc0\x5d\x46\x16"

    mkdir_p testpath/".config/enchive"
    (testpath/".config/enchive/enchive.pub").binwrite pub_key
    (testpath/".config/enchive/enchive.sec").binwrite sec_key

    plaintext = "Hello world!"
    ciphertext = pipe_output("#{bin}/enchive archive", plaintext)
    assert_equal plaintext, pipe_output("#{bin}/enchive extract", ciphertext)

    expected_fingerprint = "eb57253d-995bcf9d-743c1053-ed32723b"
    assert_equal expected_fingerprint, shell_output("#{bin}/enchive fingerprint").chomp
  end
end
