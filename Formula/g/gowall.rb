class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  revision 8
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    manifest_sha256 "e9d7d26ae2a687cab10bd89787b5cad562f0cbc92b015ac19df211b560b822c5"
    sha256 cellar: :any, arm64_golden_gate: "f55468bfe8a4d160d2ebb9478282186acf0379d6cf451066ecde523f73a335dc"
    sha256 cellar: :any, arm64_tahoe:       "6ca6dedb15953b65022ccf281006fa59fbd54e6f785660ddbd9c7af7b0e0c403"
    sha256 cellar: :any, arm64_sequoia:     "740c8fecb39b822a8245dac3e148df96af9b4903781041516f55461744e5ded6"
    sha256 cellar: :any, arm64_linux:       "6dedd32341f341fc135f725c45de511ae1d1dc993d59a3544d8f8ba66beb5cdb"
    sha256 cellar: :any, x86_64_linux:      "0b48e75c1a81724f3f731abda4064f4b59ecc1247cbf21950a82924006c0f9c4"
  end

  depends_on "go" => :build
  depends_on "mupdf"

  resource "go-fitz" do
    url "https://github.com/gen2brain/go-fitz/archive/refs/tags/v1.24.15.tar.gz"
    sha256 "086b656bbb00c314083b7097b1d295f98034f4d75ffddf4fc706a5f1c3c5cf6b"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download", "all"
  end

  def install
    # Work around https://github.com/gen2brain/go-fitz/issues/143
    (buildpath/"go-fitz").install resource("go-fitz")
    go_version = Formula["go"].version.major_minor
    (buildpath/"go.work").write <<~GOMOD
      go #{go_version}
      use .
      replace github.com/gen2brain/go-fitz => ./go-fitz
    GOMOD
    inreplace "go-fitz/fitz_cgo.go", "C.int(len(buf))", "C.size_t(len(buf))"

    ENV["CGO_ENABLED"] = "1" # for go-fitz
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
