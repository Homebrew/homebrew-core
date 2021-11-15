class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.19.tar.gz"
  sha256 "66d69ec9308dd3977f5a8911990d34eac12a30f56400534c867f8aa712b7fdda"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "95e7d90ff2e88b03a7661d107072f00c8476f42a8b19c2718eca7a871dd96d09"
    sha256 cellar: :any, arm64_big_sur:  "68d52b75fe52e2c3dfdf132c0f47f2a730984394140c9a4dcc359c01174c96a5"
    sha256 cellar: :any, monterey:       "9f67e25e2d1615e520a9dfb1708f2057c0088ca11f09feea92715d0d7da0f319"
    sha256 cellar: :any, big_sur:        "2c770ad31bec193aa392d3bc098a97f88aa6d73f18ecb6b7a93bb3526c31361e"
    sha256 cellar: :any, catalina:       "26d6fb2c103a8625d4b369ec324085e8f120b5642fcaf6a25bffa1f79ad45e7b"
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
