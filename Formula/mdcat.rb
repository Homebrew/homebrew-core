class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.8.0.tar.gz"
  sha256 "fb4ce097fff72fb53734568a8a1b96797cbedfbee2aabc2d2a5e8c794b1d5887"

  bottle do
    sha256 "71c1729d8c0db2c09f5523d0843bf1803c992aaab7b48996ae14a26c62d23caa" => :high_sierra
    sha256 "21a28bc63c7d7340e165fe49487624db6877cd2f46da8fb3fc4015ae42857997" => :sierra
    sha256 "fce050bccda3963d9e97033c914219f1833551afa3011ca819437e365ffd89fd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat #{testpath}/test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
