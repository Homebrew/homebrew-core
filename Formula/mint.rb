class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.12.0.tar.gz"
  sha256 "e828005ddeece33fbb857c808537807a844d4b9b86d1307985d6cac36b897014"

  bottle do
    cellar :any_skip_relocation
    sha256 "c935b2d5135c8402b4ca3683bfa80a95a9025cc8ab13be9aeceb0c0dd8958eba" => :mojave
    sha256 "076d4da11065a2ba39e5542e7109d1d84cbba03ff5f3bc964ead150a17afc0a3" => :high_sierra
    sha256 "3309359ee8f8b00c8c57b3361a840fc5a2917d9d212dc7bdf3f34c7327decd82" => :sierra
  end

  depends_on :xcode => ["10.2", :build]

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
