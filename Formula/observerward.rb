class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.4.28.tar.gz"
  sha256 "19a1ce91157603ffd214915943a513c5aed09591157cb4e620f9797b88e8b257"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e31041e605b2f9444fff1df75291ed7ada0de4e20d283781bbab1122ada8d398"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51f00c97897809442b6393e0fa83833b1037689b45297009f76e3f87feef4861"
    sha256 cellar: :any_skip_relocation, monterey:       "5d7cf661b42c300fb9af7f193de7ae5f943551d6024f266f68075190d425cc63"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e55fc3f7b7207c38152981880684a694c0a1f839df62d871c04c5ca6a482f20"
    sha256 cellar: :any_skip_relocation, catalina:       "99fe13d548df4bee200c5cd9d731c34ad542fdc7308e647f078dae823e379438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad098c290b8b815e81fc59ca8019c03b79181cdfa0bde1e1f9152c71f69bb77"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
