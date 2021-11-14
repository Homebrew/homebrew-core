class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.7.0.tar.gz"
  sha256 "64b1b2e397ef4de81ea20274f98ec418b0fe19b025860e33beaba5494d3b8bd1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2829a12accf1b84833f9663b55e45d0851ee27e6ac2835c6f4c3bb5366f4507d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b3c800cb9f9387eabe0820cf588be1c10cb00204bb6838c067a0f35c691ab8a"
    sha256 cellar: :any_skip_relocation, monterey:       "3456e115758dccffee255f9fe8f37258c0c22a168902683f07e4ce4a24ec54b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "56ca7dc82e101e1dbb7090fe1567c924bd967f4d3df8b138caa45182fd76e446"
    sha256 cellar: :any_skip_relocation, catalina:       "3c4f0aafa14c810b36b2d5dbeb6998bdc866aad7b531f12f14508ee2e8b1c46d"
    sha256 cellar: :any_skip_relocation, mojave:         "16deb101df03efdcc20f56ed24d2e9608e8733e3bf9f552935ccc73428ac96a3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e603cd7daf7d48e0f139b584ef77f4f59949470e4e2d0ee0f430ac229fe444ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eb0588350167e38dc14e6ba328e08faca5940c4659ef2e84d3e80533bc14617"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match "4096", output
  end
end
