class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "f92a3c0953acf4dc8d6e6c39fa89053f9e506ed1cbb1dcac13ea25ca03da8f03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3460ddd5ac0731fcbe8360bd4073dda88b3ad1584c95e04a4f10d6ad7f3ea384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3460ddd5ac0731fcbe8360bd4073dda88b3ad1584c95e04a4f10d6ad7f3ea384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3460ddd5ac0731fcbe8360bd4073dda88b3ad1584c95e04a4f10d6ad7f3ea384"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec2cfb6966da2ba98a5d6d2a005f2583b7a7f01eee11d99de45da87247eaf383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c913aea72e972eeac04f67b2c8da26e13406287c2bf3663f6c3d61d1fcff56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "245a80d951be6fc212e1898d3f5bee33c771b1683d25d5a5b7fdfa49015f917b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    config_file = if OS.mac?
      testpath/"Library/Application Support/pdfcpu/config.yml"
    else
      testpath/".config/pdfcpu/config.yml"
    end
    # basic config.yml
    config_file.write <<~YAML
      reader15: true
      validationMode: ValidationRelaxed
      eol: EolLF
      encryptKeyLength: 256
      unit: points
    YAML

    assert_match version.to_s, shell_output("#{bin}/pdfcpu version")

    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
