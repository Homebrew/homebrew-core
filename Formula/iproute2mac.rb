class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.3.0/iproute2mac-1.3.0.tar.gz"
  sha256 "3fefce6b0f5e166355fdb04934cbdd906211b64e5adb6a385469696dc51233b7"
  license "MIT"

  bottle :unneeded

  depends_on "python@3.8"

  def install
    bin.install "src/ip.py" => "ip"
    rewrite_shebang detected_python_shebang, bin/"ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
