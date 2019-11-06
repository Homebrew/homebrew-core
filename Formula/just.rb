class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.4.5.tar.gz"
  sha256 "a444b7a28ad33c19113cbb76d6678ea966a64eebd366bc889fa83aa8a44abd65"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c5d65cdbb3b707dc7d3ed1634072ffe461cbf773c3ff078325ae6252f4029573" => :catalina
    sha256 "fc8a9eb2141107aae1875844d7a3f2c63b3b9b69e25fd820d0a20ca188b6adb2" => :mojave
    sha256 "3f331c5039b32cc55fd147f7b402be36a4008f2b3c5d9626e80cff39eecda133" => :high_sierra
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
