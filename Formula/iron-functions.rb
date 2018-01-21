class IronFunctions < Formula
  desc "Go version of the IronFunctions command-line tools"
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.71.tar.gz"
  sha256 "225a3c3d5c3aadb1926383b1aca710e14b8509e0e17cafd7e076ca7390ed0317"

  bottle do
    cellar :any_skip_relocation
    sha256 "b24d1657ecb837e1ec9bb6cb1d5d6856e27d9082cc2713df3f82c1e43608008e" => :high_sierra
    sha256 "fed07f4afee783439122dba56edb99d6a2a8be427ba917a75397a351a88130d6" => :sierra
    sha256 "7c4c704f29f367e6b09c7666525d28735312645e206e309e63d870edb018faf7" => :el_capitan
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
