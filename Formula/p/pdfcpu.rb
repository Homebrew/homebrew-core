class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e36b1b03ff77fc2b9aa7ab4becfd2e0db271da0d5c56f6eb9b9ac844a04a00c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9dcb589aa980c796aac1bb901add81fd6d657a2a6cf68468e7c3f68f33a17bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a7198c11f36f618d4c11848d3eb0c0550fcbfae30593098470ec333af08bf2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df7498c8ab8dfe2a26581cdb7bf04945099f999a2e3225425cdb4dababf4f88e"
    sha256 cellar: :any_skip_relocation, sonoma:         "98c4ddb5df60aa361fd0080c84c5fdcc9e96f9081b804cce3b954b4267c45fd3"
    sha256 cellar: :any_skip_relocation, ventura:        "8884d478d03cb47554b9d81b13966867e8d79986d7c7d1056a07abbbaffd7c48"
    sha256 cellar: :any_skip_relocation, monterey:       "c15344ce623ed9b9ed496ff844550dfe9eca3fe9cc1ba307c42b0b2e4865189e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d95ac9d4ea71d40bf33c7f2c4ba7e2e821cca8b9f07a505efcd3008800bf1b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      installing user font:
      Roboto-Regular
      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
