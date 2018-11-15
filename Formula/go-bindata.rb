class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.12.0.tar.gz"
  sha256 "9b4ffd65bfad2cf7e574f04db944f3b40d31fe76cc5cbd9bfb18ede5a07040ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "17cb00f2ff5e9125d7446aa7dfb4998e4d93e5df5268531a5e1c903f3c710fc6" => :mojave
    sha256 "cba13fe94cbfb231e2d9220f2035c2f67f8305873f9028f57aecef657706c0a6" => :high_sierra
    sha256 "5e6edbbc64f6ae5df88ec037f4e5bdd11c20e42e4f0f54f2bf547d389c65fe0d" => :sierra
    sha256 "c85f2b6551af7a2a5c4cd1d19b06b263d7d76df40472ba165af2f95bb4fde25e" => :el_capitan
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kevinburke").mkpath
    ln_s buildpath, buildpath/"src/github.com/kevinburke/go-bindata"
    system "go", "build", "-o", bin/"go-bindata", "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_predicate testpath/"data.go", :exist?
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end
