class Httpstat < Formula
  include Language::Python::Shebang

  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/1.3.1.tar.gz"
  sha256 "7bfaa0428fe806ad4a68fc2db0aedf378f2e259d53f879372835af4ef14a6d41"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "219cfdfb663f1f260322ba637902065e5cad3559eeb2e338c198875f3cfd4b15"
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
