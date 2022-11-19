class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.2.1.tar.gz"
  sha256 "93c580c9773e991e1073b9b597bb7ccf77f54cebfb9761e4b1180ff97fb15bf6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bedeb1fbdd276df930ac27881c3efaba5c39b62587673d107352ad80eb4be4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466bb6d8850ef62afa5383fb4fd528fcf39a1de42f6a2bc25e3bf529b0490bc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af81af504a0ac10c6368b6b5cf371445a445fbb877a38d1e13b21644f77bb9a6"
    sha256 cellar: :any_skip_relocation, monterey:       "1627f7e3595bf79491d2df36c12b41feb7ed5454589c44de9e98ce1a182368fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a76c4af4f5cfd4ad9b24688a0f624fd43e1ab83ae8e7f5c34e3e1a547c8de9b5"
    sha256 cellar: :any_skip_relocation, catalina:       "900cf89410b055cde885fe562db77ca5bb5964dd323e9681c05976485cbc096e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e026e8afe5d1c3ffbafc18051d23b02f0ea4b09241377a1e43ccf6647b6c4f5d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
