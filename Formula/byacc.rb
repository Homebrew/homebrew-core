class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20210802.tgz"
  sha256 "2949c67ed13bd67917f0c9bcc85c76d99a3090d21105ea7672a87a3502e3ccf6"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44ed38128dc5c042da5d84a0b40f3c43eddccd6e9001a5f534ea26b7efcb87bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b73aab07380cbf30d6efe2f71577477dcdc24847e1d83b3d553cabb78781d35"
    sha256 cellar: :any_skip_relocation, catalina:      "531d8afaefc34573ad9232398af0743a3e5460a5464078a58722152415067c04"
    sha256 cellar: :any_skip_relocation, mojave:        "827930c2fa9df9256ae838ea5b3d1d8ef5ce6263bf52b10b7e8ed7a591418660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c285779596bcf30ef79f0f64ca95fa7f4a57d6e9cb5d91e1c5a938257dab6e5"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
