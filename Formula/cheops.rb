class Cheops < Formula
  desc "CHEss OPponent Simulator"
  homepage "https://logological.org/cheops"
  url "https://files.nothingisreal.com/software/cheops/cheops-1.3.tar.bz2"
  mirror "https://github.com/logological/cheops/releases/download/1.3/cheops-1.3.tar.bz2"
  sha256 "a3ce2e94f73068159827a1ec93703b5075c7edfdf5b0c1aba4d71b3e43fe984e"
  license "GPL-3.0"

  livecheck do
    url "https://files.nothingisreal.com/software/cheops/"
    regex(/href=.*?cheops[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da2855e699980221437085582629f794572878a32f953cdaef9e58f12a5f0cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfc230c6ec9f5369e775cf965cfd15838da419a0a214d390960a249fa0e7582c"
    sha256 cellar: :any_skip_relocation, monterey:       "56ebbbfb9dd3b62443b41aedea7561887f7b5bdd2414ea1a06ee9e344778d514"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab84f53943ac8bae4739c5a14913ff9ecf3fec74271d20f056189d215c46e481"
    sha256 cellar: :any_skip_relocation, catalina:       "df2ae1cf5f9b1b9ec0dc161da4d20fe4b24a5155c87e2c2466cbc26db9fce951"
    sha256 cellar: :any_skip_relocation, mojave:         "27251202d9707a3b1687094971a644aa5d34c163bb62bea0eec85373b58922c0"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a7028a380957e407304abae6f3f8d056c6363681e91792e19bbf1cde19aa44cf"
    sha256 cellar: :any_skip_relocation, sierra:         "f6087558b906474548d121bf3e745a7291dbc307d0c9ef16b3b6edd92d9dc830"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3ed8f3d4920c6c44b4d25f16402564db5639acb1e3f104329f244cd52051a9f6"
    sha256 cellar: :any_skip_relocation, yosemite:       "de719231c43b1494c0a77fe0ef97868399bd67e3c3386fecfd6564f26f4acbdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c3e683dcb5922d7060a9a8253825d79d5a699492770e3e59caca9674c9e09a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cheops", "--version"
  end
end
