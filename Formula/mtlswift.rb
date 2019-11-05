class Mtlswift < Formula
  desc "Swift code-generator for your Metal shaders"
  homepage "https://github.com/s1ddok/mtlswift"
  url "https://github.com/s1ddok/mtlswift.git", :tag => "0.9.0"
  head "https://github.com/s1ddok/mtlswift.git"
  version "0.9.0"

  depends_on :xcode => "11.1"

  def install
     system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/mtlswift" "help"
  end
end
