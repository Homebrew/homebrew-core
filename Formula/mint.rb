class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/mint/archive/0.10.0.tar.gz"
  sha256 "97f3de29ea52a9c53d0b756065002f54cceb78d1a93371e072eaf44619596bb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "03575df015e615777d1724a2192edc5ae2d1b0e5b7ddd89d9dee01554078810f" => :high_sierra
    sha256 "3cca59dd945b0994a4b26fb291fb051f238196c0dde246f793baa01b2d62eed8" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

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
