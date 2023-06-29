class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.21.0.tar.gz"
  sha256 "f00321e9333a61cb10c18141484c44ed55b1da1c4239a3f4faf2100b64613199"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19a2b76222edd3612ad6856679f1f9ad2112f177fa8767599d5521de7c88c951"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a2b76222edd3612ad6856679f1f9ad2112f177fa8767599d5521de7c88c951"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19a2b76222edd3612ad6856679f1f9ad2112f177fa8767599d5521de7c88c951"
    sha256 cellar: :any_skip_relocation, ventura:        "7107c64e1dad1ff8cae142972110788f7f23ac5156c8a8c416ee2a3608959960"
    sha256 cellar: :any_skip_relocation, monterey:       "7107c64e1dad1ff8cae142972110788f7f23ac5156c8a8c416ee2a3608959960"
    sha256 cellar: :any_skip_relocation, big_sur:        "7107c64e1dad1ff8cae142972110788f7f23ac5156c8a8c416ee2a3608959960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5a9ba0399258dc573dffa099c9ebb7446e3b12cef0268c7068153eac58f5d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
