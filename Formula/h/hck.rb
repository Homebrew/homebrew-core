class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "f6c87edfeabf33c12b08c4c585d7fece3a618a56dbd87c695ca18629ca599457"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80c37f8d57ec62a4a1cad9def4ada5e68d8b9f3cba9f92cb3dd1b9c8d0335503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a26a272867f32a7165106dfbbbfa78be9eb2897903325641bf32650ad68f0340"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56e22305a058ad39a97212158329f8a55f6a1c9365dc370ff6bdbdc6b75c04be"
    sha256 cellar: :any_skip_relocation, sonoma:        "945b035add2b676ad6e0eb2654e89088834c82a188960dd49aa861bab5e66c79"
    sha256 cellar: :any_skip_relocation, ventura:       "ab31471f5828d042a4593047b0cc8fea9206dc456ff9c3c65fd930099269fbc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cec9d7ffe968172f6e6312fe9a6519f6dcc13b84744cd120b58e8726a6d38964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d588364e3b545a16083916df392dd0cca81eaa9cd1f84eb09533b7980840b0a"
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
