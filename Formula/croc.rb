class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.2.tar.gz"
  sha256 "6d43fa18d258e85cd97e290e6183d5901a67b18eda9e9f3af67a30253e5346ca"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "096c6ea12d37915df7216b02487b4d5bdffa5b903086f698f1ab4fb2035c31d1" => :catalina
    sha256 "e294b1850bfcf360b02d631ef6bf60c37b9063629db7a6ca1b2de0b07d6cc73e" => :mojave
    sha256 "1c37140b8c44ee78832b82591f8e1ed87f7ac56c5b44f4de45e0f56b7c56d026" => :high_sierra
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
