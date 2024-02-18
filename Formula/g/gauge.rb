class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "355d473e7a829bdc76c587dc678fbf75385aa8fb64278966fe7048e8834a51a1"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02f0ee115eaadfbb28e3e75f16aab25242e58035a4a702d61c0f6e0bf1db8f46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "742038a508bf17adc841d57d76a7f86378904fbe7dcd267d7fb6775032dcd6d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a039430fa05897d246be42bf0701a3692a537cb2c9dd50679cdb2923770df928"
    sha256 cellar: :any_skip_relocation, sonoma:         "f81442848ec4c2c4446f1eeea7818fe7cc8cfec33f09054701a16dffcc421491"
    sha256 cellar: :any_skip_relocation, ventura:        "c729d3c405424e33c2f26abda91464b01b8e6fc09df209d168cf313316228c04"
    sha256 cellar: :any_skip_relocation, monterey:       "344f3f338d811778ab004e60b78e453f15ac6727a8929ee4c7ee33bd2ca7c0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9439cf8f98218a4a51434c367271a9693a7489cb2a3344457f6cd1ee31981f"
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
