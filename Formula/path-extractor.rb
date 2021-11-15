class PathExtractor < Formula
  desc "UNIX filter which outputs the filepaths found in stdin"
  homepage "https://github.com/edi9999/path-extractor"
  url "https://github.com/edi9999/path-extractor/archive/v0.2.0.tar.gz"
  sha256 "7d6c7463e833305e6d27c63727fec1029651bfe8bca5e8d23ac7db920c2066e7"
  head "https://github.com/edi9999/path-extractor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "be6cc1f4d4289cc071b1f5a17ee3c3c3982e9260e833185efa2e68db4f9df08b"
    sha256 cellar: :any_skip_relocation, catalina:    "f882b9d1c9ba8fdc8ba16d6bbad852034182636d9c968cfbacf8cc1e08009a7d"
    sha256 cellar: :any_skip_relocation, mojave:      "8feb5be3e88fa0370593d8d349a90b54ac953a504439ec61722cff7e843153cc"
    sha256 cellar: :any_skip_relocation, high_sierra: "38faa134c10a82b9ac28077d6df73da8b1ce2fed2fb8fe4f24ddebb08c18b623"
    sha256 cellar: :any_skip_relocation, sierra:      "bf30c2d715d52035b57b640d849c21e1508fb189259b5e02343f8104f50d6624"
    sha256 cellar: :any_skip_relocation, el_capitan:  "90521da4fd1834db41fbf19b7b6ce9f82a943ab2412acd41b6c5d749146770e7"
    sha256 cellar: :any_skip_relocation, yosemite:    "718512fe3585d82dee8d655c2ab534dac70d0b24a8164bcc012f0f2a65a55e5b"
  end

  # https://github.com/edi9999/path-extractor/issues/8
  disable! date: "2021-02-20", because: :no_license

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
