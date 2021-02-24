class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.22.3.tar.gz"
  sha256 "5b09423cadda34130a4f1f0af6f49728287bb8dbb94581b2dd1deba479a1271b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36db3981d1c0ecccd8505c51137b8f742b95b3372b0f96cd5d66edebd35d73fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "61f9b5935ff6b02edf87e25de955c3457d11a9d163b3ae893c116056ca8d0a47"
    sha256 cellar: :any_skip_relocation, catalina:      "e70449d7eb7d3965c90bad8892d2654f56ed0bea0aae0b729ffafeb2bc0a7476"
    sha256 cellar: :any_skip_relocation, mojave:        "665de148b7183a9c84f48e0b2f95e34f92280e46cfc2ed9c8c6fce9f6a8960e4"
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
