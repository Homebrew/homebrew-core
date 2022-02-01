class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.22.tar.gz"
  sha256 "75c5c1eb3b78701a80ad816f414640894cb0b5998a1a4d7f2af064b47a57b8c9"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "6390beb54ce375ecf751c727228481ac224a9d31b3fc570852a58db7f812882f"
    sha256 cellar: :any, arm64_big_sur:  "9f5cd2f091bc2f7681b83dabb978da766b52757e3cef9319768cefc875088138"
    sha256 cellar: :any, monterey:       "2cfc76dc15307cdd763d52019f09cd2161928ce0caa138cfc861ab649e7f98db"
    sha256 cellar: :any, big_sur:        "f26a5eb6e568dbe892daa04de8c2bd8bf0e944051242b0f897f99c34c43ee297"
    sha256 cellar: :any, catalina:       "ae0758194ca4b5b71d4907a36701545ab08cc7d4691153f735ef69328f3db2cd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
