class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.8/libupnp-1.14.8.tar.bz2"
  sha256 "5457653738a90c560eb230bdcdedef5981a2aab0f7883e31f1fe8db5369820b4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3fb2f9ad3e9dd3108ec52d81c040a9c71a5edc3579f5eeb87cfc8064e2490891"
    sha256 cellar: :any,                 big_sur:       "ecca6c90900f7c14df473e92e8c66e0b06c50526436a21f2824208fa2b037c30"
    sha256 cellar: :any,                 catalina:      "e083db16910342d9febf1bfa88a22bc749934a3040c5a5b21a59a123d358a768"
    sha256 cellar: :any,                 mojave:        "c98a8a8b387e6e00460ce6e69b0077c8687fb755b37fcc686b050e922f1f1dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20df6fc7e018c0d12d7d1eca7dff353c9f98a3f0d92c65da22ed31681275c4e"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
