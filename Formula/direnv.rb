class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.23.0.tar.gz"
  sha256 "d28bc959680a309d0d54f754edfe622cdde14a4b806fdd32d285d47a322098b9"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5b5d510abe32133caad83648afc0950dcfbf9ea0ecdd305efe155817bff0b8b" => :catalina
    sha256 "0339beb93dee2207dc3fdf9236a6a80bde6f6207dcfaee5f812d6700a8622f1f" => :mojave
    sha256 "4f66782d86962cfec8c4383d8a0195eb4f8b3df44fc707f33eb5662e5aca76b9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
