class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ff5289250cd1bfe7adef728c85c4c97aed906330e9bd79760be540eb49343d51"
  license "MIT"
  revision 1
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a3df7439031d1108856a09795c1987a4cf34ba433af05b9df0156564d60fd23"
    sha256 cellar: :any,                 arm64_sequoia: "a73e407373a63bca8bef32ce6a822496b841dbb47d448195155b9f67724e61d6"
    sha256 cellar: :any,                 arm64_sonoma:  "b4d28080704bcaaea79eb31a57ca2bd4e22f849b8932ac66e9ce326467be24e1"
    sha256 cellar: :any,                 sonoma:        "bb2a9d76c728bb6bcf5a9e6ffaaf1f7c1e64ced28d26c69c023f4b09af23241a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ee4932d127aedd167c5234b4db025d954b60ca03b1a918968afc72884c7899d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1b6bccf01dd32223c07075370e007b4b1729d4b790709d30149c24f268340f4"
  end

  depends_on "go" => :build
  depends_on "mupdf"

  resource "go-fitz" do
    url "https://github.com/gen2brain/go-fitz/archive/refs/tags/v1.24.15.tar.gz"
    sha256 "086b656bbb00c314083b7097b1d295f98034f4d75ffddf4fc706a5f1c3c5cf6b"
  end

  def install
    # Work around https://github.com/gen2brain/go-fitz/issues/143
    (buildpath/"go-fitz").install resource("go-fitz")
    (buildpath/"go.work").write <<~GOMOD
      go #{Formula["go"].version.major_minor}
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

    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
