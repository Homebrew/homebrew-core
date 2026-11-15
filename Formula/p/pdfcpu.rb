class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "d10377ca44063427b86732b2cbb110b56d10311e8961bf402889baa942d979ff"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0d57692e77c6b626c1fd3096d7ec10dc995732793641c2d75dac72f76ff353b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0d57692e77c6b626c1fd3096d7ec10dc995732793641c2d75dac72f76ff353b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0d57692e77c6b626c1fd3096d7ec10dc995732793641c2d75dac72f76ff353b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b66fbecbc66cf4280de42688a12788138d85a0d61a8dd90a91971cd837a67da1"
    sha256 cellar: :any,                 x86_64_linux:      "19cc3fdf8c7d927f6454dd4b2aa849e513623ddbd3cd3e77ba09c897b5429809"
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
