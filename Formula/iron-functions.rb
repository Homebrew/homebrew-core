class IronFunctions < Formula
  desc "Go version of the IronFunctions command-line tools"
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.68.tar.gz"
  sha256 "81700463d0ded0966cc69261112eba9d479c31dbd4006e38243ef8f818a70f69"

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
    expected = <<-EOS.undent
      runtime: go
      func.yaml created.
    EOS
    output = shell_output("#{bin}/fn init --runtime go user/some 2>&1")
    assert_equal expected, output
  end
end
