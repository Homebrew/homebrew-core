class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "79572e599deddfaa72109f3e029b74b8cd6070657355e8cc9d8c7fb91da73c71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7a311e318ce7ac9faf31c51cd7e0dc3f9657c415c46bacd73dd97396f67600"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d7a311e318ce7ac9faf31c51cd7e0dc3f9657c415c46bacd73dd97396f67600"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d7a311e318ce7ac9faf31c51cd7e0dc3f9657c415c46bacd73dd97396f67600"
    sha256 cellar: :any_skip_relocation, sonoma:        "511f2915c4d8d35199fb2fdb4ca424a4e126e3ff31893dd37c3d4f3b3d0d699a"
    sha256 cellar: :any_skip_relocation, ventura:       "511f2915c4d8d35199fb2fdb4ca424a4e126e3ff31893dd37c3d4f3b3d0d699a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f214ad4b29b091b31ac5c12235909874db4f209cf7b438b6df66976382c833f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      installing user font:
      Roboto-Regular
      validating URIs..

      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
