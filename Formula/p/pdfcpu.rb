class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "4864561bb99633c06f917eae780eccbc98b3ede259b4a774e699a893eff2a56e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17895316bced2bd2fb4e69b2ed9c94e0748530f17ec44f79997a8ab00b999bd9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17895316bced2bd2fb4e69b2ed9c94e0748530f17ec44f79997a8ab00b999bd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17895316bced2bd2fb4e69b2ed9c94e0748530f17ec44f79997a8ab00b999bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6e7fdeb76b51448d1fa592d8f959d64116cf42695e866a6297f3b31d0d71b2f"
    sha256 cellar: :any,                 x86_64_linux:      "f2a6de7eb9a57d54909fc7d101dd751842eb22ba4adaed71abe63ac4df4a5346"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
      schemaVersion: 1
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
