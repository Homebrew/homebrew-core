class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.12.tar.gz"
  sha256 "6a474ac46e8b0b32916c4c60df694c82058d3297d8b385b74508030ca4a8f28a"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0a20260fdd5e1e0906fe213cbd842e2240e885ef1b29b0e848f7c8667d91eccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc85379f2d9ff74f8e1afcf0d0cda498bd3ca785c911f0ae06e5486c7d5463f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3f177c287fb59e325e09b7b94f5d64e3b562da1a4f6183cc49e06a1763a3502"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5f99ef9dc765177761f70b92777cefb0f17df859cd263d1addc0669ed95a52d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f729292d1177fb664cc5548ef9b454f875c93fa0a1fbcbe51708f9264d21e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "a23a5f5c7d6166a0a3cc0dace982cbfa89479056bfb3b45c329a52dea918b0bd"
    sha256 cellar: :any_skip_relocation, ventura:        "909fda81a80744fd2e8ac80694258a2abf4ee52a7412fd2617d07fa61fb36586"
    sha256 cellar: :any_skip_relocation, monterey:       "5f282ad1ebb1967545d5fd96625943ef81fa89be33487da251c7fd780bb22564"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7c20c1749cc4272f95828ba80ff122e7f451f887ba84892227017146759d69d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59fefab5a530e94574f47321047cdea061cff60df562e33048af7a318b7a0492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22df39762896ca47c7d2463dd5a150a98ee005f382cfde38f6750f2a7937fd5a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libedit"

  def install
    ENV["ac_cv_func_stat64"] = "no" if OS.mac? && Hardware::CPU.arm?
    system "./autogen.sh" if build.head?
    system "./configure", "--with-libedit", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dash", "-c", "echo Hello!"
  end
end
