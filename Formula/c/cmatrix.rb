class Cmatrix < Formula
  desc "Console Matrix"
  homepage "https://github.com/abishekvashok/cmatrix/"
  url "https://github.com/abishekvashok/cmatrix/archive/refs/tags/v2.0.tar.gz"
  sha256 "ad93ba39acd383696ab6a9ebbed1259ecf2d3cf9f49d6b97038c66f80749e99a"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3e9a355625f0fde46f71845797d28ee84f3613df8ede85373b754f13ca156170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4dc801fdcf6bbf449a1b6a73a68c1ab8cfe990de6d9fbcf686c40998cd5c9f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "094d50d50af7e5365fffbd5b1f1ac6b9879d4250cd39477f45c40b136c0a6404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f50d6041ffb188ea575444bb3df18ba70d321c92e37ff40baab7ecc944dc297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7aa22beeabe078fe1e0f9a3cac02a1b8b895750a9f311ee621891b276d7012"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7df6894acc7156eefd61ac4cdfd5332b3e4165436d29cdc102ea03f03fb183ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "68d9ab783759a41f8c263c9b1d63e77056978571e738018a45ce1e3f7d9a48d7"
    sha256 cellar: :any_skip_relocation, ventura:        "1a281dff3f4e52cbc909ec3d56da455b5ac56bd918cd652ea9e3d2ee27fe6509"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3f0b2e04f4f87f62b138124b750591e5012fb3f5ebea8558371a11d7630724"
    sha256 cellar: :any_skip_relocation, big_sur:        "745b7d4d2da66a0c4d159909cb16b0b6a29647a96ac6ae74fcf3b993fd730e6c"
    sha256 cellar: :any_skip_relocation, catalina:       "fcc9c366c560e89ee2b4f61d1bdece14379a2c598719fd2eef784564bf9ed677"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f3001650675f0947543d0556e8b3338984368e8fb81eb6ffa4555523b34d2644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15aea39b9be08c26c94c9e2f8c82e977aaa7bf0884fbc4543114a52321e6cbc2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"cmatrix", "-V"
  end
end
