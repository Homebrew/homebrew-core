class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.1.0.tar.gz"
  sha256 "96ed4b74c202514987610a69af7fc71afd3b826d0449f9326661fd5244c5d5ee"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1232f15cf02fec6723e3b7906930e7fc71b17dd26ddd9754bccb970640c8d81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ca409ca5a28c37292d64ac1078f609810c106416442b280a53459958dd6ee4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1805e0e3102b9d6822d368b88778af0afb2194dbf689463da45209a1386d481f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4294a87f38ab3ca6aa7c2ed693a113fe2fb147982b0eeb33c44815447ae34b1"
    sha256 cellar: :any_skip_relocation, ventura:        "baa6923297a8d581cd91e5972fa5ec073ec6cdd5db66f660acd9e8e90508b02e"
    sha256 cellar: :any_skip_relocation, monterey:       "696739e54e1a29e4fb3e685fcda68f3857a4a88c90b32f1e5c1b980e4e5b9f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74281f92fda0e745885a6687f70a463e1db2d4ee2fcb2b54601264d3cd9e6d66"
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
