class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ff5289250cd1bfe7adef728c85c4c97aed906330e9bd79760be540eb49343d51"
  license "MIT"
  revision 2
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b1f1aa0078ac05b46c70b74261bd9f30d63a4ebab6c3ada4eab89e6b2311497"
    sha256 cellar: :any,                 arm64_sequoia: "0898329d1b65f72929f4e5ff3b0487f04307e1f5fdecc261769281f478cf72df"
    sha256 cellar: :any,                 arm64_sonoma:  "8d05f78a141972f50e304a0851597edab6792edd3c14844bb532f8555e04c24b"
    sha256 cellar: :any,                 sonoma:        "1d2a9a2c7a89efbd9562623f87587e4fc38171955464727de01b4e77fc1da775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c6cdbc1ee9bdfbab964f423a21ae86f3c65e2912ea2b4b529fc0c7862e04c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d071f57db77904d4a293c760949c5bdc01b92d6ffd9933faaae0638815cd742"
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
