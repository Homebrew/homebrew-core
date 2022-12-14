class PdfDiff < Formula
  desc "Tool for visualizing differences between two pdf files"
  homepage "https://github.com/serhack/pdf-diff"
  url "https://github.com/serhack/pdf-diff/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "13053afc3bbe14b84639d5a6a6416863e8c6d93e4f3c2c8ba7c38d4c427ae707"
  license "MIT"
  head "https://github.com/serhack/pdf-diff.git", branch: "main"

  depends_on "go" => :build
  depends_on "poppler"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pdf = test_fixtures("test.pdf")

    expected = <<~EOS
      Color chosen: 255.000000 32.000000 16.000000 \

      Image generation for: #{test_fixtures("test.pdf")}
      []
      Image generation for: #{test_fixtures("test.pdf")}
      The pages number 1 are the same.
    EOS
    assert_equal expected,
      shell_output("#{bin}/pdf-diff #{pdf} #{pdf}")
  end
end
