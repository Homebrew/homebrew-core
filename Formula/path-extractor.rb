class PathExtractor < Formula
  desc "UNIX filter which outputs the filepaths found in stdin"
  homepage "https://github.com/edi9999/path-extractor"
  url "https://github.com/edi9999/path-extractor/archive/v0.2.0.tar.gz"
  sha256 "7d6c7463e833305e6d27c63727fec1029651bfe8bca5e8d23ac7db920c2066e7"
  head "https://github.com/edi9999/path-extractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f882b9d1c9ba8fdc8ba16d6bbad852034182636d9c968cfbacf8cc1e08009a7d" => :catalina
    sha256 "8feb5be3e88fa0370593d8d349a90b54ac953a504439ec61722cff7e843153cc" => :mojave
    sha256 "38faa134c10a82b9ac28077d6df73da8b1ce2fed2fb8fe4f24ddebb08c18b623" => :high_sierra
    sha256 "bf30c2d715d52035b57b640d849c21e1508fb189259b5e02343f8104f50d6624" => :sierra
    sha256 "90521da4fd1834db41fbf19b7b6ce9f82a943ab2412acd41b6c5d749146770e7" => :el_capitan
    sha256 "718512fe3585d82dee8d655c2ab534dac70d0b24a8164bcc012f0f2a65a55e5b" => :yosemite
    sha256 "f883b0656efe0d31b35b98ab0c82d82f1fa827b39d3712136c49bae2363f539d" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    (buildpath/"src/github.com/edi9999").mkpath
    ln_sf buildpath, buildpath/"src/github.com/edi9999/path-extractor"

    system "go", "build", "-o", bin/"path-extractor", "path-extractor/pe.go"
  end

  test do
    assert_equal "foo/bar/baz\n",
      pipe_output("#{bin}/path-extractor", "a\nfoo/bar/baz\nd\n")
  end
end
