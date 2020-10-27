class Kona < Formula
  desc "Open-source implementation of the K programming language"
  homepage "https://github.com/kevinlawler/kona"
  url "https://github.com/kevinlawler/kona/archive/Win64-20200313.tar.gz"
  sha256 "3238da53bfb668e8b73926f546648bbcfbf2e86848e54c72fd3a794f3697b616"
  license "ISC"
  head "https://github.com/kevinlawler/kona.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b6a2f66ebbbaa1f13c31e8e08d0c3d9d98e1dbc91d83d6c0c7afba82dfec16f" => :catalina
    sha256 "831a58ea078f331d73ae872436bfdc1cfa7936ec116e88684ae78268c1532ef7" => :mojave
    sha256 "df2344d823528bcdb6068f591a52b6fc9f4ba9b4367ca72c44101f7acd5fac84" => :high_sierra
  end

  def install
    system "make"
    bin.install "k"
  end

  test do
    assert_match "Hello, world!", pipe_output("#{bin}/k", '`0: "Hello, world!"')
  end
end
