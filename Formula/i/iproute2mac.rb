class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.5.4/iproute2mac-1.5.4.tar.gz"
  sha256 "9548ed9ead114a3a7095890c51e0e5b1d8ea1dd955692400e19fb97f1b6ad015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "492999307c388d096aaac58390166215f920c50ec477851c495821085b7adf03"
  end

  depends_on :macos
  depends_on "python@3.12"

  conflicts_with "iproute4mac", because: "both provide same executables"

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
