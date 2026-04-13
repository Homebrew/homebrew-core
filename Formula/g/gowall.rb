class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5403ca5cf023b5555606ced24e28faf0ef8fa99b2d3ba4d5d497f041a1747751"
    sha256 cellar: :any,                 arm64_sequoia: "b4ce509d4c8106042794f659623837f8730936d96c22ea2e1538c2eb536d4aeb"
    sha256 cellar: :any,                 arm64_sonoma:  "407b60e4da340fda72f2204e5396e15fab23cffe46d53164798d0e0e8d92ecc0"
    sha256 cellar: :any,                 sonoma:        "3e556619da7d217190c237cd7b9cffbfe95cb508d2cb3f87cdeec1d8d1ff5424"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a0f193d9eb5602cb4d86d124fcc8719849ba24256fba5cbe505c1747a668cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a353d21c621447cbd989f9571412c9872947c5854ede194d5e20e5eccb0c6688"
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
