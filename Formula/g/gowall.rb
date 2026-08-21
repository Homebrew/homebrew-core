class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "df19d8a7f4d138cfa233415ad71250c788aa1a3d310b4b19ca952fb0750c0c36"
  license "MIT"
  revision 3
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "69b91c42af72503eb3b78a9a797094e29ca2463ef962a77f68569e45ddfa73a4"
    sha256 cellar: :any, arm64_sequoia: "bc76ef208c2fbb84f3bbb4a85a8c759bcd81f62e68993315cecc2ad54106e380"
    sha256 cellar: :any, arm64_sonoma:  "31f09395246c82190cf06537d916601884dd5d354d131623afba9f43e777f2c6"
    sha256 cellar: :any, sonoma:        "62eedf4c3041121b124fc8633b12481b8d91af4b51c668e5822c12c35256ccd1"
    sha256 cellar: :any, arm64_linux:   "208ef4c7b71903b8703bd025de8bb945132908addeb1af4eb78f3affcfe2d806"
    sha256 cellar: :any, x86_64_linux:  "2c55408ee00191d1d7771aaa191ade16f6ccb9d31e337b0cd36529daa7729e20"
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

    system "go", "build", *std_go_args(tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
