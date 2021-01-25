class Minica < Formula
  desc "Small, simple certificate authority"
  homepage "https://github.com/jsha/minica"
  url "https://github.com/jsha/minica/archive/v1.0.2.tar.gz"
  sha256 "c5b7e6c890ad472eb39f7e44d777da1b623930fd099b414213ced14bb599c6ec"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0ae49ee8f0a7dd9804c19e899efad38c95632c572cf440f247fbf8c902072c2" => :big_sur
    sha256 "5e6f68245edcd602ca5fe8ab2b98c5aef62e826bc1e5f6660c710d886c308bc8" => :arm64_big_sur
    sha256 "6ed3047835593e51bddc2f1150ca3db84f736c4714442140ed693e23561053ee" => :catalina
    sha256 "3665f724fc7ca7da303894232bceda5f53b3aa75d6fe010f77635f75062212d7" => :mojave
    sha256 "898ae6355e98099a2692f397b58c497dbed656a7859ed8bfb9e045fc4af56a0f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"minica"
  end

  test do
    system "#{bin}/minica", "--domains", "foo.com"
    assert_predicate testpath/"minica.pem", :exist?
  end
end
