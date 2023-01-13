class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-1.0.0.tar.gz"
  sha256 "9776fddd6caa835a2b01a32bdab08a005855a2ce18b530da35ea95ddee30e0fb"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89f68747fe7f2e9bfd913e7c0f5d2ef14205bbbb1eb2499f583fbb5d1a203181"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6465a387850444b2ee657023cc7b2ba77de253de3dd32e20c92b80713fe925dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "927e32a49334328fdeab60a9fa619cd9a9a6dff08b7928a95c437b0ced5f09ad"
    sha256 cellar: :any_skip_relocation, ventura:        "f7312ad2ca5eaebf10c605fd9fc73a39450b88bd7b77b0f29bf01ba793497dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "e3de28949b5f067dd9970d2043f329856cbc767ac5f4bddb03264c01249ad695"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa7e1f162e5b6409169f8fb4e2b6d470597898738c8b9c6b5b531137fbe70738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46649ba17441db1e6188f47bf8defda6764fdf8b8920210fe053adb264439bfb"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
