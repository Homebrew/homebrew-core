class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20230201.tgz"
  sha256 "a3127b59fe505f5e898daa3dd15b0cf724a1274ce68165b779be2f29d4c4f2f6"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ba05c5fc5035e5a29c0f5167e25016fdb8d18b5711d01a85cfb6860999802e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cc70b64fcb3d8613eb188bf3dc6f76f0892c504587119d2b547ebce6ad38fc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf97e2665a17f08a929caeab09c5975394155d0f76032bf4ed23509fd26f712d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc23d665da3e3820ad5d9ec045e1139cfb137a4439e383b5e61f838f5ec7c21b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b61602751b2c137abcc72d825a0eb18a3267121a3f321237e525a6a6fdb5795b"
    sha256 cellar: :any_skip_relocation, ventura:        "27973d203ddaf933c0b6493e08f2496d63ca59cb279db31f3d39380f209f9243"
    sha256 cellar: :any_skip_relocation, monterey:       "8ba1559246e72fa3c8f1fbc1562235c31029db9ccfb0af928db98dfa440ec4f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "18c339245ce5f5fd91800677a2e8a518336b4ddafc81c101dc656b3d6e88f759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42905caef717c108acbdb69a3de34cac6329f1635ad77cffaa3db67dbc27815"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
