class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "http://lav.yar.ru/download/le/le-1.16.3.tar.xz"
  sha256 "0be61306efd1e6b511c86d35c128e482e277e626ad949a56cb295489ef65d7b9"

  bottle do
    sha256 "a1c7c17792d36b71d8d638df984e7583e873ada961e3a9f95adf43c83005b00d" => :el_capitan
    sha256 "36884568ab31a33098a472994adb9d2a5950fc713a1aeed9dae1ba5ff3fad81d" => :yosemite
    sha256 "e8afe5fcbb5b40311216d0026b2b74caef69ea2289ae971ad29664290a10d8b7" => :mavericks
  end

  conflicts_with "logentries", :because => "both install a le binary"

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
