class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "69924a7363ea19b4f3d4799ebf78bcabfec75a735c9569983a6e2834b5e8c6b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9b49c8c5a894d6e6e80cfd9dbef28033d26fc83c497907625d012bfd8eb8ff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b49c8c5a894d6e6e80cfd9dbef28033d26fc83c497907625d012bfd8eb8ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b49c8c5a894d6e6e80cfd9dbef28033d26fc83c497907625d012bfd8eb8ff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c337d706a85d5577f81fd45abb9b3ad21226c9aefdf9092b75ff3a8cb03165"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af3a53e00dc41d3ad9bb4ce473cb18c8af49ba38e4051ec7990ae559d3f446f1"
    sha256 cellar: :any,                 x86_64_linux:  "86b1cd8dce6af8d0cba20388938747e408ac2309c108fe368f9a749663393eff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")} 2>&1")
  end
end
