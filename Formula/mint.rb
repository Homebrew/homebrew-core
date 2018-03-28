class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.7.1.tar.gz"
  sha256 "986dd967b818ee044ed0568135db8be2083ad6c3995fe6281ada9b42b224a2ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "045fc8cd11d8c3e9edca5588140194ee83416f887b254ea27b3288f0fa5cbad9" => :high_sierra
    sha256 "ef1b5a9609d98627c82a9a49c5daecd52aacd633fa92814282b92e1c3b6f0217" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "--help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
