class Mkp224o < Formula
  desc "Vanity address generator for tor onion v3 (ed25519) hidden services"
  homepage "https://github.com/cathugger/mkp224o"
  url "https://github.com/cathugger/mkp224o/releases/download/v1.6.1/mkp224o-1.6.1-src.tar.gz"
  sha256 "772d4b429c08f04eca3bc45cd3f6ce57b71fa912fa6c061cd39f73bf2fec8e70"
  license "CC0-1.0"
  head "https://github.com/cathugger/mkp224o.git", branch: "master"

  depends_on "libsodium"

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "mkp224o"
  end

  test do
    assert_match "waiting for threads to finish... done", shell_output("#{bin}/mkp224o -n 3 home 2>&1")
  end
end
