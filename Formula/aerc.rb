class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.9.0.tar.gz"
  sha256 "b5901feb37a55edd1f713e76c1012ac3fc0757202ddacd7d388cc7ce60638023"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_monterey: "cdd48ab11d276a08038cb4658a27ce84194bb846afa466e13092d5e07514f7e6"
    sha256 arm64_big_sur:  "e73ee2bf4aa2d611e589927c84c3dd94c1aabda01a77d07c6cfcecaf5dab0def"
    sha256 monterey:       "69ec4cdabb778f96cf8de9e6e4b1b960f0cf84b8fa40e5d2febffd53122c135f"
    sha256 big_sur:        "1adf5c2ec24d14ccf3ac53a16155ebdc0344ccca341ec847d5a0f52c68a8d20a"
    sha256 catalina:       "fd45807590d9bbc0c17ce120657df9b229b63ff4462b067dc75709bc0a6a8702"
    sha256 x86_64_linux:   "cb57248c88b8988f1fa9c45a0d39cd35c5c12cabbce1c4699c72f85493787ea4"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
