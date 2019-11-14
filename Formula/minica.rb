class Minica < Formula
  desc "Small, simple certificate authority"
  homepage "https://github.com/jsha/minica"
  url "https://github.com/jsha/minica/archive/v1.0.2.tar.gz"
  sha256 "c5b7e6c890ad472eb39f7e44d777da1b623930fd099b414213ced14bb599c6ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e6c8aee5224159bf91d3c48e7cabdfdb1ad07dda5a08a8e46a06b3b6985fd9e" => :catalina
    sha256 "b9e770340412c61c71cee5c4428fb43bc3204615c826f3a2daabca42869cea66" => :mojave
    sha256 "52bcdc795e10b9fffd91984fc50a17c68c658f409ff545c6d94e147f2adce66a" => :high_sierra
    sha256 "de8de2c3f4a630f159186701abd9badd6d8f086fabc47984af857d809c28e822" => :sierra
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
