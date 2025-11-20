class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.6.0/iproute2mac-1.6.0.tar.gz"
  sha256 "11a4059f1d804084ac22a6ef0f71444f9f3e59485276c706fc914e779d916b29"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0d85742fb0bdd9665035fffd6c8870d91702aace1438c8b0c2c507492e0f462c"
  end

  depends_on :macos
  depends_on "python@3.14"

  def install
    libexec.install "src/iproute2mac.py"
    libexec.install "src/ip.py" => "ip"
    libexec.install "src/bridge.py" => "bridge"
    rewrite_shebang detected_python_shebang, libexec/"ip", libexec/"bridge", libexec/"iproute2mac.py"
    bin.write_exec_script (libexec/"ip"), (libexec/"bridge")
  end

  test do
    system "/sbin/ifconfig -v -a 2>/dev/null"
    system bin/"ip", "route"
    system bin/"ip", "address"
    system bin/"ip", "neigh"
    system bin/"bridge", "link"
  end
end
