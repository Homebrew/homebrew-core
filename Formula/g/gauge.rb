class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.18.tar.gz"
  sha256 "103d4a567e9e9bbd2cfc9569603f6069dc3c8787d76eeb7ae93787aeea7db68f"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b62c7fefa282d27d7eaeaaea76f8d992763d9c2c1eecc549ed60aedb8280bb8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349b054ffb0e21c9f84fc82ad44755492afbe584201edec255f2a24a50ca6233"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "136b22a5610ae6f4e55539e9b2afa512e4ad8a19d07f41722fa760e1b42da6b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "52396c3f28540de2592ea83b17a4876b07c58aa67a8a2c8d77066cfc15a3485f"
    sha256 cellar: :any_skip_relocation, ventura:       "74727646b7faa9dd2db5ea4884910d0decba3b3438aa60d2c274d406eb787a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "413ec6f235552142c5b93c836bc44c1a554eaf54011e18582dda667cba60ed26"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
