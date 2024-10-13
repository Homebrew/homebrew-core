class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "4ca78450414f405c892c26b1663cac6e56a86e1d04529a7b1a69b23881c38414"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4e22655013ce29dc3aaf2aef3f7c8a6e86fffea03467e20c2fdc521c2b5b426c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86cfd0af4c611bb66e40cfea7d2d88e231819a84cc9b52eabf1101c51744ee47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4573660ea7606a3d479eba1a215baba32327d862981bbeb2a88028f04b21516"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d97dcb1be41061ec99862f720fb241dbbab70d158ca09896bf664291be3d6ef4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1859dcd0ac4a801579b813c0c6ba11333091b5f6e5fc8f6265fd8d248582c646"
    sha256 cellar: :any_skip_relocation, ventura:        "0d0e6ebda0277dbd55583f984d9e67e22e3c59244e25e6983772c83f36cbf326"
    sha256 cellar: :any_skip_relocation, monterey:       "5579f894280cf996c8081487fc932cce497bf5bc9d232e6b2a5d9cff66c92e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35de8ef94e14f8a3f204755c943dfac83aba854bfe6c48d5300fed387673c0b7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotter", "gen-completions", "-s")
  end

  test do
    (testpath/"xxx.conf").write("12345678")
    (testpath/".dotter/local.toml").write <<~EOS
      packages = ["xxx"]
    EOS
    (testpath/".dotter/global.toml").write <<~EOS
      [xxx.files]
      "xxx.conf" = "yyy.conf"
    EOS

    system bin/"dotter", "deploy"
    assert_match "12345678", File.read("yyy.conf")
  end
end
