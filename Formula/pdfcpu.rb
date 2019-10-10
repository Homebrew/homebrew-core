class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.2.5.tar.gz"
  sha256 "bf2920cc595dd34f4297e851063fb095eea23575db43c53547910749c703261a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f4351e012f4555f26d71d4cb3f4ee6891775e59d4d54af6f6281379d84f7fa8" => :mojave
    sha256 "db507b177cd84c9d0b0d423d28793939a60f5e5f4b6bc4f7c850f4962e830fa6" => :high_sierra
    sha256 "61c73c66edb2fa1d0a68143646362c507af5a1bfb3e15629f311ef23bc890bb9" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/pdfcpu/pdfcpu").install buildpath.children
    cd "src/github.com/pdfcpu/pdfcpu/cmd/pdfcpu" do
      system "go", "build", "-o", bin/"pdfcpu", "-ldflags",
             "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    end
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match "PDF version: 1.6", info_output
    assert_match "Page count: 1", info_output
    assert_match "Page size: 500.00 x 800.00 points", info_output
    assert_match "Encrypted: No", info_output
    assert_match "Permissions: Full access", info_output
    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
