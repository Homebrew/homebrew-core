class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.1.5.tar.gz"
  sha256 "582eb4d9c06634b1cf9035f1b3e7d8eee67a8e759f882ca6253e8b33184928ae"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3cb115adbe75c287533247f54f18b5b76f8e32f77ae977085a28d5fdb657dfcb"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4ede664b391c78c5addb6b10c423db872a879f0b7d9324aed23628b8d28aa5b"
    sha256 cellar: :any_skip_relocation, catalina:      "00f2a6b8007c5fc6d0e3d49662933a9a26dc63e7933742a99694ebb5192f96fb"
    sha256 cellar: :any_skip_relocation, mojave:        "c1c3cea350756f3398805c61adf045884465fa4367f7477a2522170099683839"
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
