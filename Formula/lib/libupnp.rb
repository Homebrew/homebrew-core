class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.24/libupnp-1.14.24.tar.bz2"
  sha256 "8dfde05f63e91644e907dcfb7305955ad064b4cf6e5103cb37a7c57c50d1dd11"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e403cd816e8de10c22429564e2236d5a050637adbfef519dd5b3d77608bb66af"
    sha256 cellar: :any,                 arm64_sonoma:  "04df71a03d9b1b3d96d79b9d3f8d36c1d824abc44cdcaaf64bb35a8e4af7d383"
    sha256 cellar: :any,                 arm64_ventura: "224f178d28e917c2884008949a3324a3591932fcc5dcbb72fed9f3b05162b700"
    sha256 cellar: :any,                 sonoma:        "493baa1f587afae4b317cc04bd6eee8a595e0658bc466550d3a72b54ae879258"
    sha256 cellar: :any,                 ventura:       "0098a2e2db061718ab02149ad3a70d71f6ba4450c406a814952a3781460f8da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5e4ba4cc9118f956eebb5a99eadc0e8185495658b76b62901118cb6baa49ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8fb4ff72b291065c68d8640c7d54728773cc9937c9cfebda2b557ed972f532a"
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
