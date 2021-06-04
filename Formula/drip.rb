class Drip < Formula
  desc "JVM launching without the hassle of persistent JVMs"
  homepage "https://github.com/flatland/drip"
  url "https://github.com/flatland/drip/archive/0.2.4.tar.gz"
  sha256 "9ed25e29759a077d02ddac61785f33d1f2e015b74f1fd934890aba4a35b3551d"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "11c4a909bf8a51be3923be6647126524769f8580898d6b6035fe4a9e95d5c415"
    sha256 cellar: :any_skip_relocation, mojave:      "fae4ea200256b46fea345cc1ac3c2b312fc235b6f6988a7d078145e44ebe7331"
    sha256 cellar: :any_skip_relocation, high_sierra: "6fe1110fb43b5e32e16c9053675313468ca0fbdf92d3ec9f0c9d5be105e4c409"
    sha256 cellar: :any_skip_relocation, sierra:      "5d84f90eae53dbd9055e429d42981933cf5f3a2f213862ba7892643c5289e9df"
    sha256 cellar: :any_skip_relocation, el_capitan:  "69a071055da45949c56df74c4959336f9511f863f447aed941a66547169f2c88"
    sha256 cellar: :any_skip_relocation, yosemite:    "14711be9325c0b2df465197156b4b78bed673bf441011d0ce29d48a0c2ee0045"
  end

  disable! date: "2020-12-08", because: :unmaintained

  depends_on "openjdk@8"

  def install
    system "make"
    libexec.install %w[bin src Makefile]
    bin.install_symlink libexec/"bin/drip"
  end

  test do
    (testpath/"Test.java").write <<~EOS
      public class Test {
        public static void main (String[] args) {
          System.out.println("Homebrew");
        }
      }
    EOS
    assert_match "Homebrew", shell_output("#{bin}/drip Test.java")
  end
end
