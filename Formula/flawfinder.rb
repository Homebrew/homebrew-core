class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.6.tar.gz"
  sha256 "d33caeb94fc7ab80b75d2a7a871cb6e3f70e50fb835984e8b4d56e19ede143fc"
  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "412abf57cabd235508b8d1e96ab97e7c3672a377e7e96d604afde44fd33c5504" => :mojave
    sha256 "360aa8f3a3028978f57b5432e9e0927d6c7a2baafd5bf72ad742daeb0cf7f521" => :high_sierra
    sha256 "360aa8f3a3028978f57b5432e9e0927d6c7a2baafd5bf72ad742daeb0cf7f521" => :sierra
    sha256 "360aa8f3a3028978f57b5432e9e0927d6c7a2baafd5bf72ad742daeb0cf7f521" => :el_capitan
  end

  resource "flaws" do
    url "https://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
