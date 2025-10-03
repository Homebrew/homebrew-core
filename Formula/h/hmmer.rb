class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.4.tar.gz"
  sha256 "ca70d94fd0cf271bd7063423aabb116d42de533117343a9b27a65c17ff06fbf3"
  license "BSD-3-Clause"

  livecheck do
    url "http://eddylab.org/software/hmmer/"
    regex(/href=.*?hmmer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1f42eea650a3ca55ba74920ce46d7e9cc019f203881097a0ee7978516c867f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3342dd2de2909df5053dea525398b3e3902b07a1d58dab35a940bb7bf77b877b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0b23b02bb7bf3113ad01b32f5410ad7e1aade6186e5b54f788bc4c5345ea7d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6285afc40e6975a1c8c0def48bc621e91801995481683954e580529fe4a5ae2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c32f8196a92df90112d84a4478ff8621ad2682074765fb956e6eb47a2ad9a86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37ffb9e206f2bd9a6bcfc8ec0209ef879057293ec0cf3588c083e6948c51c548"
    sha256 cellar: :any_skip_relocation, sonoma:         "dccdc668733d08a039d2ae9c5c40e4aef51c7b3bd8ed87398bc4159b7275cbef"
    sha256 cellar: :any_skip_relocation, ventura:        "1158f5420a01acc1906a56f654c564dc1538fc7961472f4a00598875b474f7c3"
    sha256 cellar: :any_skip_relocation, monterey:       "454e0ba7a19efebc0ec14b06d0075c377fab5ffc69c2a2fc7c54a2bac6406d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd8305a219c8084fa7fa34915fb904837b172fe7f3aafc8d6aa3c4e9a6f919d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fdfea197f9b659764a9a641cd3bd27d10d27f53c116801332b2074d40fd3b9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6de4e838a141d9cd836421806beeb8fea120434756ab1897a7dcd2d6e858e0ae"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/Pkinase.hmm")
  end
end
