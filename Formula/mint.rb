class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.16.0.tar.gz"
  sha256 "bbd258ba5e79da579b0d0526c55c5141382df638a1fb139e02fa92a66b608be4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "599c2482d15b729dc72ffa23d38599d551a42b70b81079b9a573cd91bc78d8d0" => :big_sur
    sha256 "eaf4c91e17438d0968ff29a6429c55f93c0aa02614f2c3f7a1a4b106375dd085" => :arm64_big_sur
    sha256 "376d67667e9003d503368e39d89a2592dd91daec615310bb2fad3d9ee971d8a8" => :catalina
  end

  depends_on xcode: ["12.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
