class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/SpinlockLabs/iproute2mac"
  url "https://github.com/SpinlockLabs/iproute2mac/releases/download/v1.2.4/iproute2mac-1.2.4.tar.gz"
  sha256 "ae15aa4eb81be9cdec56e0005d806e8a1d2f9f2a91fafeb1eff67fe23e93e1fd"
  head "https://github.com/SpinlockLabs/iproute2mac.git"

  bottle :unneeded

  depends_on "python"

  def install
    inreplace "src/ip.py", %r{^#!/usr/bin/python3$},
                            "#!/usr/bin/env python3"
    bin.install "src/ip.py" => "ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
