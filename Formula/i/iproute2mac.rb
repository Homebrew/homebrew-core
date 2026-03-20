class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.7.2/iproute2mac-1.7.2.tar.gz"
  sha256 "b2460043a49f83e93f534dd7ebf31d1e3394df1c70e0a299682815bc63ff295d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a374f057368efb8bf3cf999f5176cff71db4df06d4df35bd5a7abc4898ff30dd"
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
