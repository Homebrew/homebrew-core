class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "5c39e754c465709ced7f62289a837a37808bf48f355b8ef4608cfa9d8e32536f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a46fbdaac66c81f2564886c8825fa64f7f6edd89db4a7821e2625dfe8324056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a46fbdaac66c81f2564886c8825fa64f7f6edd89db4a7821e2625dfe8324056"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a46fbdaac66c81f2564886c8825fa64f7f6edd89db4a7821e2625dfe8324056"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea748757c656c8c781769904c637e9cab7114733444ae3251bb466591db4182d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91bdd0f9769e18d9fc8adb9f143f08d4111b6cd4f038e3927bc73ec988706878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6575c5b6801c7fcb8cb008f1378f5f3669b3464999897bfe46311349b7fa7e5f"
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
