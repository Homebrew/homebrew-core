class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20240917.tgz"
  sha256 "f13c2e0ae9034b64e8a30f7a0228344b68c76a0215e0c12a9650852a4cec91ce"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d543a71f77b6a9ef7ae4497c5114153a5fbe35cb5d610a8b3b8c472b2709b20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415b0a2c2f3a201a6382957c0ccca9d79fc4733a0ed4f335f782c45861de7845"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76e722eee04aac5c5ce137cba0c031e42581003f5b27e0e9eefd45011e8c5bc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3790cb06332cdc0c857a1e780d4edd9ac899d69d4a1a08047b61249ad40456c6"
    sha256 cellar: :any_skip_relocation, ventura:       "2b082e9a692aa8e77fea3c96eb48a25ca75b45a6599207a4ecc2b2e10b1c91b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15cd7515cfbe19bfc6cef04b30a3f4bc56104fbbd790c1eeab2d59d487078491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99e6dc868a2b3bd6fcf189124cccaccdd1322ee18a51dc23055e8579d2e28e8"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_path_exists testpath/"test.txt.orig"
    assert_path_exists testpath/"test.txt"
  end
end
