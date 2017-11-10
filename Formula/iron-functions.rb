class IronFunctions < Formula
  desc "Go version of the IronFunctions command-line tools"
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.69.tar.gz"
  sha256 "92814a6049b20d7e6a9c3653a25484a50808a080603251bea6c63b0caa074d91"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd5e796945b3bfae759d28ff32b64ef4a41c2442241dd49ec1da14ad42063a5d" => :high_sierra
    sha256 "6ca9ad0df6b6d17ddfe0b357ed0af5cace0d23575a4336615b2381812138fd95" => :sierra
    sha256 "575c789703ce06c4d2c70000e170729665419ac3e5d9cf4891487cdfaaaf3289" => :el_capitan
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
