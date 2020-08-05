class Gcal < Formula
  desc "Program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "https://ftp.gnu.org/gnu/gcal/gcal-4.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcal/gcal-4.1.tar.xz"
  sha256 "91b56c40b93eee9bda27ec63e95a6316d848e3ee047b5880ed71e5e8e60f61ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bb8c5727fb336106016d1158796e0a127fc82eb630ec9e2bccb6d70327aa531" => :catalina
    sha256 "39c897bb2106251109af642741220e8b92e19c52be37ef928258eb1a2f6230ff" => :mojave
    sha256 "0a1e3ab27fcc8d08d78452074137dcdf281068c41a732a64222e9b5ed235e8fb" => :high_sierra
    sha256 "f120585bc8538eb1ab7c71ec240b150472cbf7b42e7fc6a3f008c15104d81e7c" => :sierra
    sha256 "c94d7232ff507f387fad5ba5fb0d09b1548e695cf7e1da284846a5ee828f2d03" => :el_capitan
    sha256 "b50b10e57eea6d6fa84c35769401b0da3bde02bade28e137bc1263d492c60c3f" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
    system "make", "-C", "doc/en", "html"
    doc.install "doc/en/gcal.html"
  end

  test do
    date = shell_output("date +%Y")
    assert_match date, shell_output("#{bin}/gcal")
  end
end
