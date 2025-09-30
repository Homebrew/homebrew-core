class ChinadnsC < Formula
  desc "Port of ChinaDNS to C: fix irregularities with DNS in China"
  homepage "https://github.com/shadowsocks/ChinaDNS"
  url "https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/chinadns-1.3.2.tar.gz"
  sha256 "abfd433e98ac0f31b8a4bd725d369795181b0b6e8d1b29142f1bb3b73bbc7230"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3ad68ee0eade8b16d3698f5f38f91dedb795c40f6776be6458feb36576fc3e48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d7f5135d04a85b3d2eb3db7d807d091f45b6c7047613d73538fe8e3fd92d2fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b959cce820a04d88db10395e6823303d9dba2a789215626b8eea0777f88dada1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962e197fda53c506ca1a8a11ab883c4e7b154a12ea747219b4add76e8fc2cc0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b400b323f97ff6d0570ed5b2ccffc2325516dea3c12d6ee18c5903ee2d607f3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a5921a1eb32cce03417035e20ed9fc3c52569bbe3cc963f4a5d8dacd8a61bd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "46f3927a44604a56d4263e14756379a34d06e4a5037f8e98c7cb73f2cba42f80"
    sha256 cellar: :any_skip_relocation, ventura:        "25c8e721baf2e9622339fd932f96af2e331aceafe6188f196536455cf4e77f20"
    sha256 cellar: :any_skip_relocation, monterey:       "3269038188274afa37cfbc4155f9aac9d63c5e47ac0e1cae9b10eb3e6eab63b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d15cde6788156aa67dffd280752d52f5aac1ef1e8f56c8e5864ce05b9c81647a"
    sha256 cellar: :any_skip_relocation, catalina:       "0c4820f0e5a12421b0e64c3cb993608560817a446b8747e7119838cb271b9044"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8b321cf1fe2ef28e58d94d640c4e5fe6fd31b0974efec84541ccf7c431b9a48a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7158e876b817917183a78e96e891dcd9ff9cefe333d1b139c73f9209fd585b0"
  end

  head do
    url "https://github.com/shadowsocks/ChinaDNS.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"chinadns", "-h"
  end
end
