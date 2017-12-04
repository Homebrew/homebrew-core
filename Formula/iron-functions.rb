class IronFunctions < Formula
  desc "Go version of the IronFunctions command-line tools"
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.69.tar.gz"
  sha256 "92814a6049b20d7e6a9c3653a25484a50808a080603251bea6c63b0caa074d91"

  bottle do
    cellar :any_skip_relocation
    sha256 "831bf1e125e7f98e4a954a9cd2643ed5d8da0ca875755ea41d4e3e13a51cd3a1" => :high_sierra
    sha256 "93a44cadfc23f995d90985c5ba9282dc8d95ddf202ec9227109178231e0efc11" => :sierra
    sha256 "de0f0b61cac685f7942a0491fd8dcd2f56de4b367afa081e8b7654c42a9116f5" => :el_capitan
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
