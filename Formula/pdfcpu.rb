class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.8.tar.gz"
  sha256 "7453c666570e8b93d9b71491f9b36192f80aafb43081ca9643cfed401341f465"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "081c5cfc66ac6e82bdaa4b6046d568fa10ddfee6d47cc856a5008916c431afb3" => :big_sur
    sha256 "8dcbe1329da171b75344c74bcb4a66748e53bdf3f258ae248b141ed184b69083" => :arm64_big_sur
    sha256 "401e9a0ea88ebf9bdaf06012458bce98676018cdb43855c1c60c322c3fe112c8" => :catalina
    sha256 "b2d4eeaf342b8aabc26b98c2e88b3d127880fed48c80e41bd4f106f6c9f61d43" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"pdfcpu", "-ldflags",
           "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}", "./cmd/pdfcpu"
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
