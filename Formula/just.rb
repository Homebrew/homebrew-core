class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.1.tar.gz"
  sha256 "aaa9feb2bb52a0667dfea0019059d884c249d519f27e507c0e9a02b83cbfb321"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9be2d50fe1269d14f0531352bc655a14dd2b4938a4557749d2e27fb1524bc1f" => :catalina
    sha256 "7e33838ddadf76bbe75b28740ca5d4c4ec68637277fd7d8f4fa535a8f1fc9b25" => :mojave
    sha256 "257884a665efb5c175ed8e98f36cf5d9f7bf9fd8cfb88d4ab3bdaa39ab2d0c12" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
