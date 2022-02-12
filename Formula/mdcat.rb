class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://codeberg.org/flausch/mdcat"
  url "https://codeberg.org/flausch/mdcat/archive/mdcat-0.26.1.tar.gz"
  sha256 "1120c4f3b5b517075b6347dbfe76a2211a91837b4d0242c0b72cdbc19e6886dd"
  license "MPL-2.0"
  head "https://codeberg.org/flausch/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e450a947d840bd6ed967f796c3ac20b645907b5a5a7e723cd294601bb5e38e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ddb52338aae3c74c93785f2032a2d444c6741715742731c1755d9547e90eaff"
    sha256 cellar: :any_skip_relocation, monterey:       "1fce50454732f9dfc98e0675946dd9f3c8cab5d38537cbd286413d8404329406"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ae99f84394b6ab2a8c2ea7461d8f8dd00d05c189223f5186fa206fd282f2940"
    sha256 cellar: :any_skip_relocation, catalina:       "bbf93e222fc49642ba5dde42ef7bb1ef6128aac7df091cc1b9260b34c579ec4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1dbc2a75907812174e291b1ba20f784645750cc9bd82827831df3e87c39ca3f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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
