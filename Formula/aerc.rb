class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.9.0.tar.gz"
  sha256 "b5901feb37a55edd1f713e76c1012ac3fc0757202ddacd7d388cc7ce60638023"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2435e2a4e07456ea5b92bf946a7c21da7f36479d516b7c5655af6c7c8aa4618"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d544bb72649b4eb2ddd17f01da2d6f5f1f561c4453da7b3f0022a4b3a988c1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "26419d852acd5f14a1b0953e01fb4b0e19a7dda264fb603eba56008e885cb001"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c1659e7b5fcc4c6ee89739d946b5143b95b19ed4f5af97a8dd8b1b23e2b296c"
    sha256 cellar: :any_skip_relocation, catalina:       "88a79365233df3773f99b6f9ee8b27b38fd89c71c6899c57754a949c23b13e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d676b3ccc0608c88f9d30d7f8c9a68d7899201ebbfb8ec98ded2b27155b79266"
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
