class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "965624c0d714d8ae2c3db06874ae37973d37bb7815ea4eeec7c761ffc6143a1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "df52f242e09d30a14e6ec4ebc23ec2ca1d877626f0544d9a2ead02f49ae373b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d845c4b5d4641e81975f4e167fd3d1a0ee3a383cdb5dbc15740143479251408"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d845c4b5d4641e81975f4e167fd3d1a0ee3a383cdb5dbc15740143479251408"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d845c4b5d4641e81975f4e167fd3d1a0ee3a383cdb5dbc15740143479251408"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ce2bcc28878ff73e75439f77e0b5caa4f632fff21ff3d8fcffcdc735bd406d3"
    sha256 cellar: :any_skip_relocation, ventura:        "9ce2bcc28878ff73e75439f77e0b5caa4f632fff21ff3d8fcffcdc735bd406d3"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce2bcc28878ff73e75439f77e0b5caa4f632fff21ff3d8fcffcdc735bd406d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "094f73fc7b36b47e08691f438d6a45a97649eccf8aa56eea7fc5a747578d63c7"
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
