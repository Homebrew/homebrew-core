class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  revision 5
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08e2127ae4603be20ec0967a93f871a22658723ff3a727a1082a97a3a81faa0e"
    sha256 cellar: :any, arm64_tahoe:       "fc987a3f35632681a0187066a3e5a8a4a80c2b5e269af93be7ce4edb21283336"
    sha256 cellar: :any, arm64_sequoia:     "d8efe5a11419c0862df701474b1369a24ab87ed56ef1770540005baa7cc6751f"
    sha256 cellar: :any, arm64_linux:       "93d59d8f5c0480e60997cce8cb0a44519d225e196103035f45d8479a502be0b5"
    sha256 cellar: :any, x86_64_linux:      "cdffa5c6803a6d9aef798d731f2d749c72363c4faab2c7738cd10c5c571e556a"
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

    system "go", "build", *std_go_args(tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
