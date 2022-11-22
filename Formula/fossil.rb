class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.20/fossil-src-2.20.tar.gz"
  sha256 "0892ea4faa573701ca285a3d4a2d203e8abbb022affe3b1be35658845e8de721"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89e51154dd811ac8be85bbcc2602efc7cf8dd28176dd9417f9cc5c5945938a9e"
    sha256 cellar: :any,                 arm64_monterey: "7c0149b6e906560ac63a35967a77077b58e2de7297b4dc844e207291316cdf84"
    sha256 cellar: :any,                 arm64_big_sur:  "782fb74c7533f298d51041ea2cd5ea7f11a21be8dffa17aafe14b07a1bad4074"
    sha256 cellar: :any,                 ventura:        "39c5a281948b24e3efbf4ecfcdcd808fd00a4f7239059d93c3bd5a9af52bbd2d"
    sha256 cellar: :any,                 monterey:       "2285ad847450f89945b07ba7caa986e2e9cafceccf91371ef208ab26a773ceeb"
    sha256 cellar: :any,                 big_sur:        "0cb70e6db0223cc00dcb754b2f5ef1493ee83cc029e362a7ef26ab3be64c86b9"
    sha256 cellar: :any,                 catalina:       "4c9c1a29c411dfbbaa62817737b67e15d21c90afd4dc40d96f21ba07022b2a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b040996f1983d95ac0ed7c3b18bfc2293ac9fab4cea5baef68ed21f31c98c281"
  end

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
    bash_completion.install "tools/fossil-autocomplete.bash"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
