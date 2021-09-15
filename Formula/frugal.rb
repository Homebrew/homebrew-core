class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.8.tar.gz"
  sha256 "7695911bcb09f89a6303dca0309b2c713291f741ca4f9487428df67712312584"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c48bf2458ba6396f0db25011e095433de34f4b697189a93781a624334058a1a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2050779ecfa4ac1f4f4bb980030635203deff41accfe662c75a8b266abb074b"
    sha256 cellar: :any_skip_relocation, catalina:      "f2050779ecfa4ac1f4f4bb980030635203deff41accfe662c75a8b266abb074b"
    sha256 cellar: :any_skip_relocation, mojave:        "f2050779ecfa4ac1f4f4bb980030635203deff41accfe662c75a8b266abb074b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3501e8678664c49becb0b73aa6f1cdbb02c81fb2812d42fc771fd8f876aa4cae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
