class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.4.1/iproute2mac-1.4.1.tar.gz"
  sha256 "f85558ea41a128ad5fcf30ae04ae272d4414b1cf6c8be06bb116ee41178cfaa1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "eb6014521de7f35e1b16bb7465d9541355d981befff05dfe044291b234cf15a7"
  end

  depends_on :macos
  depends_on "python@3.11"

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
