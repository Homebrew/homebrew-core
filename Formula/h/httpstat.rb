class Httpstat < Formula
  include Language::Python::Shebang

  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/refs/tags/1.3.2.tar.gz"
  sha256 "56c45aebdb28160dd16c73cf23af8208c19b30ec0166790685dfec115df9c92f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4c6ac7e7f5619376d294d7921048b7bfc2745c280518b2ce977f8091d5536ef9"
  end

  uses_from_macos "curl"
  uses_from_macos "python"

  def install
    rw_info = python_shebang_rewrite_info("/usr/bin/env python3")
    rewrite_shebang rw_info, "httpstat.py"
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
