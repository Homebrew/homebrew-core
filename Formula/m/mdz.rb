class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "16b0e877091c1ef6fc466e52c4281a9407081459264f3c8bb7917699687224fa"
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
    assert_match "Mdz CLI #{version}", shell_output("#{bin}/mdz --version")

    output = shell_output("#{bin}/mdz configure --client-id 9670e0ca55a29a466d31 --client-secret dd03f916cacf4a98c6a413d9c38ba102dce436a9 --url-api-auth http://127.0.0.1:8080 --url-api-ledger http://127.0.0.1:3000")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http://127.0.0.1:8080", output
    assert_match "url-api-ledger:  http://127.0.0.1:3000", output

  end
end
