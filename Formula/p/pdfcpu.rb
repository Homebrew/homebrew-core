class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "a07cc50446ef6526fa26d5fe2c9e207724971e0b6917f3d70680ec39cfc53aec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbfe66486cb5610e9b1dd03580ab566c557929770eb73938aa092b2f6cf7bbad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbfe66486cb5610e9b1dd03580ab566c557929770eb73938aa092b2f6cf7bbad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbfe66486cb5610e9b1dd03580ab566c557929770eb73938aa092b2f6cf7bbad"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d543ddf966abd6bd5b0a3e24cc0f2d79567e6de3d79283aaf973e341de0d8b7"
    sha256 cellar: :any_skip_relocation, ventura:       "4d543ddf966abd6bd5b0a3e24cc0f2d79567e6de3d79283aaf973e341de0d8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913e9c226dc778530c8a0941460bf3cb5990070a8763815bc263c3e6f32063e3"
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
