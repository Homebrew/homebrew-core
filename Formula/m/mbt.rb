class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.31.tar.gz"
  sha256 "b4d7d8a226728cd73d34b5f3255cbe6b745ad920daaff3f5c0265bcb688e7818"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16765b382a547e7fc5285c87ce46bc5f863aa6f49252c245526d4ee49583fc31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9436b2972a50ab062b6edd8d3491e5b4709c34258dffa5f65c7b4d6bf05a480c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1bf638b389d371cba3ecc4e21dcb13f2548427641acf43e265d22529fd8b05"
    sha256 cellar: :any_skip_relocation, sonoma:         "93d1a08f229ae26df0d1a7b7b464c016dbf4c96664faa47ebf8b9b9ae88a6432"
    sha256 cellar: :any_skip_relocation, ventura:        "ec34c587a106f3e4cfb998622681685419e1aafb979c99491bbb2457b3040653"
    sha256 cellar: :any_skip_relocation, monterey:       "03bc22bebf8085091ecae34fab474e25f4fa8b31a227c44dfba89c9151f29f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41f319d087901f5dc9c31f0eb9f5ffe55245d2d8226b1ad7dbcd7581071ea03"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[ -s -w -X main.Version=#{version}
                  -X main.BuildDate=#{time.iso8601} ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
