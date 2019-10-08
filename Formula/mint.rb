class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.12.0.tar.gz"
  sha256 "e828005ddeece33fbb857c808537807a844d4b9b86d1307985d6cac36b897014"

  bottle do
    cellar :any_skip_relocation
    sha256 "222269e6e53604eaf15cd8e728703c4dccc202e1502695e0c188b5742555ff83" => :catalina
    sha256 "7f35429cee3a119cec153464933146e380364a4006bf88dcd93103584e02ec3e" => :mojave
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
