class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.5.0.tar.gz"
  sha256 "d705e7040e87c3835e54f5602724c400170cdc2c22281deec15f2f7deb5842c1"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b88af8a4f1ebd41a5df4140d98b5273b86604d2c59608033b28e9017107008e3" => :catalina
    sha256 "fd2274ee228e6509f7005b695e5d43fc755aa922811d184f01ff71264dbb6691" => :mojave
    sha256 "1529fd2b4aef9ce850827e2b5fa8723cdb883c527f109014df530cc9dcd43003" => :high_sierra
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
