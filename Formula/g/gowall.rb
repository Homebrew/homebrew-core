class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  revision 1
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "17471adb6bb4c2c336971f7e07d60406933a1ea6a68ed664a421b49c0247a19b"
    sha256 cellar: :any, arm64_sequoia: "3a56b959533e29f8ee7f62c53e2a50b0d692a1e055721f6fda10fd80bba3c039"
    sha256 cellar: :any, arm64_sonoma:  "7eb626a9c549b931830ef6b1a72a855c09213e01416a3090d15a72bb5026bcaa"
    sha256 cellar: :any, sonoma:        "8e12280c0163694b9485dc22523c3455f3dcfcb646cc5332dbc4bf3040f70b00"
    sha256 cellar: :any, arm64_linux:   "d68a9e63d56ed4142bc2893b3f04f1262d929f8959ac08a7b13c05ca6d80f9db"
    sha256 cellar: :any, x86_64_linux:  "96af85a44feb35d4d6cdc0dfe447d45d5a6881b1d6e469644e0b1f968d675692"
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
