class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "be3d5befc9be00119257c63e47051042e594770706e1e3c16e453dc2bc806ca2"
  license "Apache-2.0 license"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.ClientID=9670e0ca55a29a466d31
      -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.ClientSecret=dd03f916cacf4a98c6a413d9c38ba102dce436a9
      -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.URLAPIAuth=http://127.0.0.1:8080
      -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.URLAPILedger=http://127.0.0.1:3000
      -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./components/mdz/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
  end
end
