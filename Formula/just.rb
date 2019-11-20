class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.1.tar.gz"
  sha256 "3fa32e3479278c9288c761e7cf7a64d8d0984d599fd3ebb8606dea6343a7a92e"

  bottle do
    cellar :any_skip_relocation
    sha256 "12ce776ba05ab47c57750ef686843990dbd813ead88f88ac3776093c348b4414" => :catalina
    sha256 "bae90bb35985fe758921aede04fe5ba12923305939785e4e52cb8263ae25eb37" => :mojave
    sha256 "48f88775c9500f041781d55a9cf7fe699e5f62619586373a6a5ee305bf49f9c7" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
