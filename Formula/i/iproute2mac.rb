class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.7.4/iproute2mac-1.7.4.tar.gz"
  sha256 "8850fb1e0e18f525bd4f4b43d9e2a072a730b8f19e9a24b00713f8e43c1e1392"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73a5c180e64746ede5cf8d531bcaeb0d0f52bf19a7e2401c12dc02dbd5b3ad9b"
  end

  depends_on :macos
  depends_on "python@3.14"

  def install
    libexec.install "src/iproute2mac.py"
    libexec.install "src/ip.py" => "ip"
    libexec.install "src/bridge.py" => "bridge"
    libexec.install "src/ss.py" => "ss"
    rewrite_shebang detected_python_shebang, libexec/"ip", libexec/"bridge", libexec/"iproute2mac.py", libexec/"ss"
    bin.write_exec_script (libexec/"ip"), (libexec/"bridge"), (libexec/"ss")
  end

  test do
    system "/sbin/ifconfig -v -a 2>/dev/null"
    system bin/"ip", "route"
    system bin/"ip", "address"
    system bin/"ip", "neigh"
    system bin/"bridge", "link"
    system bin/"ss"
  end
end
