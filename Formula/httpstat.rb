class Httpstat < Formula
  include Language::Python::Shebang

  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/1.3.2.tar.gz"
  sha256 "56c45aebdb28160dd16c73cf23af8208c19b30ec0166790685dfec115df9c92f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e4abcd3c43514f792ffcdc766d65e22f37b8b1c66d5bb89828c73d33b06f7c1"
  end

  uses_from_macos "curl"
  uses_from_macos "python"

  def install
    if OS.linux? || MacOS.version >= :catalina
      rw_info = python_shebang_rewrite_info("/usr/bin/env python3")
      rewrite_shebang rw_info, "httpstat.py"
    end
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
