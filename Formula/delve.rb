class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.9.1.tar.gz"
  sha256 "d8d119e74ae47799baa60c08faf2c2872fefce9264b36475ddac8e3a7efc6727"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "163915298a3ab5062e158ac2eeaa5a46d4ce0d15c4f9c0f872b25bb35cd9785c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7e1c7ba5b4c4dca7615da8556969bef7b850c416e0918d9e5c2872910b28108"
    sha256 cellar: :any_skip_relocation, monterey:       "84f17947f66a9bf7a137ae2fac723ee3450b79b38e66918b9081f0bab6147384"
    sha256 cellar: :any_skip_relocation, big_sur:        "10e2b9101211aad9772cf566b4b643b18be7363702359bbfae468be0ab6a2e8e"
    sha256 cellar: :any_skip_relocation, catalina:       "073d5b00115ddf6502bff91f81b3e57681a60683308ba95ec8b4eb9b335db725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad0a5963670d044c1ac5cb83272350b25ad9db356ceaa4f730f38607a79b404"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
