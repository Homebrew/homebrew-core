class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.10.tar.gz"
  sha256 "d8ce1a686c93d190bc228689450d50f956fe8064c9b72dbf5e5da566c2a347b2"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4fdfc73e14bf045974df0085cf8ede3bab05e6cce85bc753750ee7f59023c177"
    sha256 cellar: :any, big_sur:       "b4ddfb4e394f8e5479ef6b4e276a41544cdf6d5fa66a2ed1daee82931dcad668"
    sha256 cellar: :any, catalina:      "fda0754f2fb92654baa11d1f8fb20baed947d9770dbf5ef67e6211fd9a00cd7f"
    sha256 cellar: :any, mojave:        "6be3fc4d92ccf797da1a59a9bfdb664c32d2f53a0cb1a6256b301ad86b123aea"
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
