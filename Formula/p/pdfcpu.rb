class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d7e657051aef697d39da63a5366850d476485b33d5ad100b829b86153df8c094"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac0374501ea12b2af335cc3dbbee4242fe7d1f8356800c7d38c550865aeca0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ac0374501ea12b2af335cc3dbbee4242fe7d1f8356800c7d38c550865aeca0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac0374501ea12b2af335cc3dbbee4242fe7d1f8356800c7d38c550865aeca0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0692dcf8d08edafa081826fa09cfc16195bc45c7174f5e07da2ab6a8e3456f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3976935844e64c9fc47bd0b1dc3789ca7fd636b26f65fd47070b8f7eaa16cbf0"
    sha256 cellar: :any,                 x86_64_linux:  "04958b9fac91e60a8b19011e51b7e3f241aa33b5611f998eebf5471db30ab5f5"
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
