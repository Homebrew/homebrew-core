class Httpstat < Formula
  include Language::Python::Shebang

  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/1.3.1.tar.gz"
  sha256 "7bfaa0428fe806ad4a68fc2db0aedf378f2e259d53f879372835af4ef14a6d41"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d9ac6f7d7da555221bffc4f49b59f60bcc9405439e5d418a49f15a547026dd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d9ac6f7d7da555221bffc4f49b59f60bcc9405439e5d418a49f15a547026dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "8d9ac6f7d7da555221bffc4f49b59f60bcc9405439e5d418a49f15a547026dd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d9ac6f7d7da555221bffc4f49b59f60bcc9405439e5d418a49f15a547026dd5"
    sha256 cellar: :any_skip_relocation, catalina:       "8d9ac6f7d7da555221bffc4f49b59f60bcc9405439e5d418a49f15a547026dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f239a4cae556fd6c19412f141b409b8a347bc83a1cc1f4fd337c04da9c79fd4"
  end

  uses_from_macos "curl"
  uses_from_macos "python"

  def install
    rw_info = OS.mac? ? python_shebang_rewrite_info("/usr/bin/env python3") : detected_python_shebang
    rewrite_shebang rw_info, "httpstat.py"
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
