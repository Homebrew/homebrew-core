class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.10.2.tar.gz"
  sha256 "d32be438caabc3e527a812e809f0f004dfede0959c8099e3a5ce24b526a464cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fcc244edc519247c82378563ce937a72a9aec0ac40d33e2a5140194f34d4e6b" => :high_sierra
    sha256 "19efd0667200c49dff2c1bbb3987e2347cf2ad4d67b65aeb504802f0f7aff1a0" => :sierra
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
