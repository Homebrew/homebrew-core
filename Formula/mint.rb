class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.9.0.tar.gz"
  sha256 "25d3dbbc3ae331d5c0d65d370457c69449dc043298ae4eea76fcf66d89774407"

  bottle do
    cellar :any_skip_relocation
    sha256 "482c527434751571bfff509e949ae33d76e0123d5cf418f1d9ebc686929cda1d" => :high_sierra
    sha256 "203cfa99c47358497dc58deb7d0a689859705da12b7591d79d9d425eb1bd62e2" => :sierra
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
