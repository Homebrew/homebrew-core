class IronFunctions < Formula
  desc "Go version of the IronFunctions command-line tools"
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.72.tar.gz"
  sha256 "8022db6eb7354003810bdb98250d4c2931dacb527dd1a5369686c9674b5ef649"

  bottle do
    cellar :any_skip_relocation
    sha256 "743b1308eca68a0ef30ee1477283fb70cd551b803294103aa5d2ea2087e47977" => :catalina
    sha256 "04550579304bd5d9a86fbe77a6658f058895cc21c64f9a15946ff5a9267508ac" => :mojave
    sha256 "0c7b0ffb269c9f977cd2c10d7bd838257ff49ebf9bf99967deda27cdcdc3420f" => :high_sierra
    sha256 "9a2edabc008d14c1eabbda2cb0c1368a39b69f842d78f2b9fb0fd25d50cabeca" => :sierra
    sha256 "874a0fb12f7aaca58e8da405a0930cb108fd505a547355ac4bc8ddceec083816" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/iron-io/functions"
    dir.install Dir["*"]
    cd dir/"fn" do
      system "make", "dep"
      system "go", "build", "-o", bin/"fn"
      prefix.install_metafiles
    end
  end

  test do
    expected = <<~EOS
      runtime: go
      func.yaml created.
    EOS
    output = shell_output("#{bin}/fn init --runtime go user/some 2>&1")
    assert_equal expected, output
  end
end
