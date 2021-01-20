class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.30.0.tar.gz"
  sha256 "5074b8b7e1a9ca7b96a55512737ad2cac8d92de22964973724c5f5424f98e177"
  license "AGPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "18408a1b36d5bd61dbf10fc55e83efaa33b358e51fc5d2a91879c9049c5d0f10" => :big_sur
    sha256 "0e85503cca920ecedaa16511deac86a088ce1d49f422bc6101210abd7eb03567" => :arm64_big_sur
    sha256 "b7bd5708af3593bb66e252e35d37aad25c8f2b86686ed53f67d438cb0da4adc9" => :catalina
    sha256 "0eb5aa720d0a1bc5b306e7c7e4d767a346b7073f14e018bc866a5e2540cd9423" => :mojave
    sha256 "037428689ad82115999e98f4f8967f615339e9c9f3e9211d0935ac63a73fbf20" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
