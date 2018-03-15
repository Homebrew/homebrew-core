class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.8.0.tar.gz"
  sha256 "fb4ce097fff72fb53734568a8a1b96797cbedfbee2aabc2d2a5e8c794b1d5887"

  bottle do
    sha256 "77ed15875a6379f7c95a95af9eee53b8f7cb6c295d2df43ef49f4932865bb5fe" => :high_sierra
    sha256 "a363e294b323dfc469b7f7f22519457eb3df834f6407ffec8f40c1935c1e5e24" => :sierra
    sha256 "9c84c8b1c3d6269b0c9fd4badfb79e7e9fa5cd332d8e7345acfdf69122b7bb95" => :el_capitan
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
