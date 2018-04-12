class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.9.0.tar.gz"
  sha256 "25d3dbbc3ae331d5c0d65d370457c69449dc043298ae4eea76fcf66d89774407"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca92b710132014dc54eab352fa0f9e7718a4884be278ebe28b56ce2e0337edc2" => :high_sierra
    sha256 "e6c65f935cae525de75819dff74858e5697a6c3fe11e5c33e9897dac02872609" => :sierra
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
