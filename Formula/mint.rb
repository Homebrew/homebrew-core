class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.10.2.tar.gz"
  sha256 "d32be438caabc3e527a812e809f0f004dfede0959c8099e3a5ce24b526a464cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c7809eed9921e8d6b32a9d58656a7aebb593c00f4567bdea869e5be534e01c3" => :high_sierra
    sha256 "9d328139982de23b815e2dc8ce08213c27f1b097eee8480dcc1ff2be1fd7973c" => :sierra
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
