class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "a15d61b50e432b90b435e59728fde241fdcb745eba06f437cbf106aafc7ff2d0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f423e614b6a4d1765e57de61487850b34bf63ac206b2982f4c3a5e5b82f50271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f423e614b6a4d1765e57de61487850b34bf63ac206b2982f4c3a5e5b82f50271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f423e614b6a4d1765e57de61487850b34bf63ac206b2982f4c3a5e5b82f50271"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab3e25520b6c1120fd4e25f2e6da50886760db804eb1a31ac0b9f756957e5dff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7165211f222952e921d166198596b8a27086d49dba8638f70b7d48f498ebd9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72529330d9aa8c2d205b2763fd6d39e3664e76f2aeea7758d14a74c802db4103"
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
