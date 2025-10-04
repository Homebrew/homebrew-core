class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.2/posh-debian-0.14.2.tar.bz2"
  sha256 "e78cc733c13087398548acdebf1d805ee5520fc2d9e190d4a7e33ab63a4fde82"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{^debian/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3ca3975b323a5129749c73735cc8b7ec32c00201f9162eeceef9eabb8229b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5521ebcdfc7adeb500e695de86c246a35ea196081c7685a57df8d7843ff018e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd77d2ab476deb15961b1ada548f29239c0e1522a4215bf60f86599364e99974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "395839fc84859a9d46173aa90f04ce21d71ebee46969d78ad478ba0daf55a559"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2612844178de8cdf96374c59b161631d45ed1329a86f0cb3b89ec86ac9a25e4"
    sha256 cellar: :any_skip_relocation, ventura:       "41cb17fbbf01fabd160bcb42a7a3d3eb8081b620c8c067c05e2317118e89e747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15eaeb12495305a8341399582b4eeed3a7632bde7822960e94f22349acbaa32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6255ff6feee66604318f82a9ed6ad93ce1aead32500374506321ccc0b2c3d4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
