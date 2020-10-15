class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/2.7.0.tar.gz"
  sha256 "3a6450316ff62fb07c3facb47ea208bf98f62abd02783e88c56f2a6508035139"
  license "MIT"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "076781a169c35bba3b5bac8b4e5ea89497b9e21993da49739b4d3b690c4fad2b" => :catalina
    sha256 "f680ca7c613325854b5d93185ec4db42a94341d8c4556b9e76adefe90d63eaf9" => :mojave
    sha256 "83a6bf89d47c2347c30872201ea5a77c8af18ada90b1992b28838d10882c0c6b" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DMAN_OUTPUT_PATH=#{man1}", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
