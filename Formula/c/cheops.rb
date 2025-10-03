class Cheops < Formula
  desc "CHEss OPponent Simulator"
  homepage "https://logological.org/cheops"
  url "https://files.nothingisreal.com/software/cheops/cheops-1.3.tar.bz2"
  mirror "https://github.com/logological/cheops/releases/download/1.3/cheops-1.3.tar.bz2"
  sha256 "a3ce2e94f73068159827a1ec93703b5075c7edfdf5b0c1aba4d71b3e43fe984e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://files.nothingisreal.com/software/cheops/"
    regex(/href=.*?cheops[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e22eb2ee77f28f3738d572be8a83cee17e20ee6c0a23919defdcc601443f4e5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a19ba4057d685a8f61ecc2d198d517ae6859cf4a0479a153f3959ef832d45e20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1de166d2e9dde915555db3c19377561aaea388583f255b84819ed8a0e0c1aeae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665487e5600fb7c185f31a9a5dcc5a5e9e819bd13b6cfdcf4ccf613a4e6f8cb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da2855e699980221437085582629f794572878a32f953cdaef9e58f12a5f0cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfc230c6ec9f5369e775cf965cfd15838da419a0a214d390960a249fa0e7582c"
    sha256 cellar: :any_skip_relocation, sonoma:         "076e721715c1e395dc11889d8bbd2a2128a36e496846de3537ed93f510f90bb1"
    sha256 cellar: :any_skip_relocation, ventura:        "1d04d8df7dddb24564f4ce0698f8a59ce7cd9aafcf600e27281ef65b307b42cf"
    sha256 cellar: :any_skip_relocation, monterey:       "56ebbbfb9dd3b62443b41aedea7561887f7b5bdd2414ea1a06ee9e344778d514"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab84f53943ac8bae4739c5a14913ff9ecf3fec74271d20f056189d215c46e481"
    sha256 cellar: :any_skip_relocation, catalina:       "df2ae1cf5f9b1b9ec0dc161da4d20fe4b24a5155c87e2c2466cbc26db9fce951"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f7c9ea482150858e6ca729be10c9d215d50cea55d411b237c3ebf45cf355c7f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c3e683dcb5922d7060a9a8253825d79d5a699492770e3e59caca9674c9e09a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cheops", "--version"
  end
end
