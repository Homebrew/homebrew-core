class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.5.1.tar.gz"
  sha256 "2ab0a479196b8ca3f024d5dad7e42c871e043a846c14beb374c48f2c172390d7"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "340fa1bf5bc2d4b287e3be95cd6222794496fdc6e4c13a066b96a5f6a688ee3f" => :catalina
    sha256 "67a0048c9b7412cebe8b403daac3e66c32e45e0526856ac6993270d2cc216f27" => :mojave
    sha256 "6954a2fe024b2d6b03759ca20b6be83b17e3b4c1574481914bf057c9ad9a1ba7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
