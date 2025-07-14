class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "16e6e4fbcf809f9d737d8931c267220e5e4cb00fbce793eeaa4501193b954c55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f141222f26821c8e9a2c6b359b73fee48040cc04ce127dd209968ef80e68d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f141222f26821c8e9a2c6b359b73fee48040cc04ce127dd209968ef80e68d39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f141222f26821c8e9a2c6b359b73fee48040cc04ce127dd209968ef80e68d39"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fa423d0867b75c977cede4c3b81673b91919d9bf564967bbe7b30232aab6755"
    sha256 cellar: :any_skip_relocation, ventura:       "6fa423d0867b75c977cede4c3b81673b91919d9bf564967bbe7b30232aab6755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb75f27ec1367eeaeaabd10745b1c30ed25e7588760461db93bd7b8a18553c29"
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
