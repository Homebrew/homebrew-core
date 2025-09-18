class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20250912.tgz"
  sha256 "46958060e66f35bcb8a51ba22da1c13d726d28a86c1cf520511bcf7914bef39e"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d986c063be4b909b0d9d114e025ce89eecd6797a01330a94b0fdc8989ced7354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445930198971ca03c36a2f98cf9c86ee055aafcc5deda6b568df75938c1ca852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e56ae508014af8c4a7a3fc1ccc656672c5abffa4ded9ded3272006adef3538"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe568b0437c8ecb441292f60d1d354192068ab9aa14f33e6c794796fe4946731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c33c1304bdef843e8e1d941e1b4d1429e095b9b3d4266c3d5a29f0340d93ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8bc415c330cfd9747ce7ecfb31783c56b8a0a2b89a615301e88a6b27793684"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
