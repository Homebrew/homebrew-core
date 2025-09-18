class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "3012aef73b3ef5e8b100824af0db2131f81771338fec5f9fe47dc71bf3782506"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "25ff59636e9bef5700315f86f48a67a2efbe09e339903bf4995e3129b542c4fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bfce04e9d779487f7d4469abcd3be17916615d499f84a06e0580911cbac1ee0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6ee2f9dd4398cc8a6897481e0f799cbe79227cedc35623c5d0a8c8e6d0895ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "349e4cd6b80fc83621693d1e68dd4e5c6ab29aa5259eb76edf8926e22f29e8e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20e1eb2ccd61e211cd3c6bba229b4ccc15ec3594337e20be2f68a2b141fd22c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "489ea944bbbd2aeb68925d26e2effee5520155564cd031a6294860445b4510c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bd36f17cf4c9c41ec1bb88df4adbae47f6b537c20517becf4a8026950fa842e"
    sha256 cellar: :any_skip_relocation, ventura:        "8b2e9baa7b521954bea1cecc6c5259808fdff948fa776902a328f18945414b22"
    sha256 cellar: :any_skip_relocation, monterey:       "d7c1fa10458fe1fedd754d8b5aa4bc1160abd305cf70078bc1d7e1c9caf385a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdc9b107c8cecaec93dc476ff09a6649c4bf4a9604ee98ce9748d53c71fd9f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "846cf810013ef2647155242db628236d9dc7a4647152bbc84aa941c41916d01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc509264acdf417f6ae40d102132fddd7ec95c4130c05bfb5d7c4c468f5b3dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write <<~C
      int homebrew_test() {
        return 0;
      }
      int main() {
        return homebrew_test();
      }
    C
    system ENV.cc, testpath/"test.c"
    assert_match "homebrew_test", shell_output("#{bin}/bingrep a.out")
  end
end
