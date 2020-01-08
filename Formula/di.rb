class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.47.3.tar.gz"
  sha256 "9339281811b10704dc80c2059294e4ff8c74b2687dfcf282d1c56950d4ba9654"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4b64171a6e90bc58cfacbf2cfe0f8bad54ace4c2a5e566e0dc5bd0a31acc151" => :catalina
    sha256 "67db1cb7a092f8bc638ee8221d88944b7d49d347a124f1dc9dfabf9f5391ba1d" => :mojave
    sha256 "951df832d9e3d0c3c580ae567659e470321ea4097928a19e385d884007f37d9a" => :high_sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
