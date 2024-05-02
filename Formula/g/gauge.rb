class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "48944e91b2fe09e97dd5f8988774b9f12a405b47cdc852c5906946c746822fa4"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09de87e7e9ad4494de5359eb992416633b0ce202f8261c3f3a095465fe3ab2f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d728dda975e9d222e1480cdfb3a5fbd7f3df3424335d265d603ad8c10de2f171"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67dbbe6a86458a7a39ec210f5562a3f6943f9662537697c1c7de6231b9edd13a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cae4c861fa4e373445e7bd5241d6eb7d16df978d2174b53417961061f8c6f3a8"
    sha256 cellar: :any_skip_relocation, ventura:        "aacbca59f6dbbb379eb853a728f6b7bfd0a41ec1e99dab91c163b1a333e228cc"
    sha256 cellar: :any_skip_relocation, monterey:       "f6a7f571359afbbe30a559890fb37833683ff93b65387a2acad26abf1e0591ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c469c97a4d3209244627bf6d1164595cd3c0fc8dbf9de786799dc07afaf0c56"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
