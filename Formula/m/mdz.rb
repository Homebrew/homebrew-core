class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "071e9139dcce744446ecc0cb65b5a27f3a9e6c18be928c52d1b096a9bc87232b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3abdb8a41b205efad10ab9b33ea4bcfb359c484fd30f9ae6b4b3d25f89cd463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3abdb8a41b205efad10ab9b33ea4bcfb359c484fd30f9ae6b4b3d25f89cd463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3abdb8a41b205efad10ab9b33ea4bcfb359c484fd30f9ae6b4b3d25f89cd463"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f87f357797ddc1fc99bc4678ad91de10d06b7899b0c1d4a72c9b8c68d7943e1"
    sha256 cellar: :any_skip_relocation, ventura:       "2f87f357797ddc1fc99bc4678ad91de10d06b7899b0c1d4a72c9b8c68d7943e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e0298ad031024dc9ed5add93f2e2d31a9c5f3cfa13a1606963fb84cfd33981"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}/mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http://127.0.0.1:8080"
    url_api_ledger = "http://127.0.0.1:3000"

    output = shell_output("#{bin}/mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http://127.0.0.1:8080", output
    assert_match "url-api-ledger:  http://127.0.0.1:3000", output
  end
end
