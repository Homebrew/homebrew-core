class Knock < Formula
  desc "Port-knock server"
  homepage "https://zeroflux.org/projects/knock"
  url "https://zeroflux.org/proj/knock/files/knock-0.8.tar.gz"
  sha256 "698d8c965624ea2ecb1e3df4524ed05afe387f6d20ded1e8a231209ad48169c7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.zeroflux.org/projects/knock"
    regex(%r{The current version of knockd is <strong>v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f84095e2b3b16af1f3d2263b79dd3432f9dbc9db27654377d520fdb54a0c520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81bcc7e4f700f88fd52678bcb97fe0eddf0a562e28bd406268ae263e286903dd"
    sha256 cellar: :any_skip_relocation, monterey:       "964a0505b7d815efb5be3a9ecf3e935d19e07e8fb9245fc292dda30501d089cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d423345658b70c35b16a032ace493f1da244144dbfe0f4c4b0ed79ce0ac560"
    sha256 cellar: :any_skip_relocation, catalina:       "2c9a3167f4b08e9b4ed890f6cc165eda8e813da9c911e741fd9cdb5d3742de31"
    sha256 cellar: :any_skip_relocation, mojave:         "5af91e5dcf61f216105c1562c032f2d06decbf6f6653171793d6af2101e27f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ee3bfd7171b2fd896bda24b35ccb710365acf17e8c87b01d6a119a5133d996"
  end

  head do
    url "https://github.com/jvinet/knock.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libpcap"

  def install
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/knock", "localhost", "123:tcp"
  end
end
