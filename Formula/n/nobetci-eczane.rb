
class NobetciEczane < Formula
  desc "Official CLI for Eczaneler.ORG v2 REST API (Duty Pharmacies in Turkey)"
  homepage "https://eczaneler.org/nobetci-eczane-api"
  url "https://github.com/mehmeterdogan/nobetci-eczane-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "744794e3af7883c267b272cb224a6b7a43e248dca44232b791194d8bd5b61b78"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./main.go"
  end

  test do
    assert_match "nobetci-eczane CLI v1.0.0", shell_output("#{bin}/nobetci-eczane version")
  end
end

