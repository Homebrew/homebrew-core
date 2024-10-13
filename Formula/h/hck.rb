class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "8aecac1a52852f238390e9e20c85b14846d1b6c1035920603d1a8196396896d3"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "21450a28d64eda3776cbc703afbb39c26d293114e465875f5ecba49c1825a453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "982bfb5992b79fedcd55c78635b869d00a82588c61d19db1f6ff40ec52f0544d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aad26fabf6f8b16a6022ed9bd107a8cefbce21542d48fd180b0b1fb476c1493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04da72de485181504132aee5fdc14f6d39e406907f8a055fede41d835ce44b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "901841a1c43b4a15143122f9e3d6d14c34d8030f036e9a4296705589804e0eff"
    sha256 cellar: :any_skip_relocation, ventura:        "f4799e2d8f41ba474efc42d7dcc0bd8ee3d831d2fa29716dfd9b1dd54c823a4c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4333a0f8ab5446cc998e60c27f32585c6e2474d236983e6a27d06af03e7de64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4507e7f70a48f62704e80070cf9aa43b6419f579c6ac9061da5e2165dd8d518d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/hck -d, -D: -f3 -F 'a'", "a,b,c,d,e\n1,2,3,4,5\n")
    expected = <<~EOS
      a:c
      1:3
    EOS
    assert_equal expected, output

    assert_match version.to_s, shell_output("#{bin}/hck --version")
  end
end
