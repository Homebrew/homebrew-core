class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.41/src/nspr-4.41.tar.gz"
  sha256 "c562b8ddfe93704b7dc077be013f01448fdc6c124b1821c0f10471a71cb2e9e6"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7858925e0755df4973feaddabcecc7d3a8dff43145dc070a48597f01ce134d52"
    sha256 cellar: :any, arm64_tahoe:       "5dcb6d1b73ec8c839dacd46dfad6d34ab2cde7339593e106aaccc20cf72ddb62"
    sha256 cellar: :any, arm64_sequoia:     "afa910ba680a2a951e5e624ff83f756ba7a53a2647cb1aabdf602cb94468eee2"
    sha256 cellar: :any, arm64_sonoma:      "3025c0bd9a1ed60c1aedffb36475e0eef6a4666500959cf2386ca7180a9d7db3"
    sha256 cellar: :any, sonoma:            "33eb0744b19504a815418fea946241fa63823ca513ac5be37a033429a0422ccf"
    sha256 cellar: :any, arm64_linux:       "cd749cf5e8f3c20589baeab68214f55b5a9e39207bc4d39ba127a4e4b686a984"
    sha256 cellar: :any, x86_64_linux:      "0922c5d8889e433afa933295c1627185d6d92f2c87d422d6d6a84e074bf6340b"
  end

  deny_network_access!

  def install
    ENV.deparallelize
    cd "nspr" do
      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-64bit
      ]
      args << "--enable-macos-target=#{MacOS.version}" if OS.mac?
      system "./configure", *args
      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system bin/"nspr-config", "--version"
  end
end
