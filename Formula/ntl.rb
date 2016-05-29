class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.8.1.tar.gz"
  sha256 "52572595cd1a3b93b5b622168dda4bce7954471cc8f7d5b4c594187259e5ca43"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c80f485b943143a51bcc9a4e0a07c856f9e144a7eb9e0283f77234302a9d95f" => :el_capitan
    sha256 "5d79a7cbe3f93fb8d0eb1cf64c13d26db61c99cbff98034b0828eca51dfcb49a" => :yosemite
    sha256 "68c86d6e81d649ee2a91ff0c17e431f9c1a5aefca2e51288c6847581e24cadb4" => :mavericks
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
