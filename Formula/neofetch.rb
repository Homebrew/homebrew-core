class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.43.16.tgz"
  sha256 "c7c2901c7a16a56300a90c7280d25265771cb2dfb332e921d4fc4825d988ea22"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb1cbc74bba6487b48d9c7c6f9118bd49ce0572751f42461f52341d9b0b43f86" => :sierra
    sha256 "eb1cbc74bba6487b48d9c7c6f9118bd49ce0572751f42461f52341d9b0b43f86" => :el_capitan
    sha256 "eb1cbc74bba6487b48d9c7c6f9118bd49ce0572751f42461f52341d9b0b43f86" => :yosemite
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
