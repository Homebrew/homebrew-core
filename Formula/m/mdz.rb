class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "5f31cf26c9effd2053cba92ca6dd270da784a13f0be778af24fb048fcca9bab4"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "705e407166b298ac726eb60ecc279cad5b53cbd76a0220316a9f36c2fec06d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3cbf62efc45a886f2f77dd4ee381035e91e2c4c3a1c8c28228e6950b609f210"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22696d579a1d284b7eb628dbbd06b9839432d0a861cea2515db65beb85add57"
    sha256 cellar: :any_skip_relocation, sonoma:        "c311356fd323475d8f90652b926e6b69544c8bda54d992ee9f385fa6a69dc0c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b45455bac45f8d2c9119c7c683dc1acb2c57edc8749ebc1a8e17a4a21b5e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431fdb1309616fec839ff927f3c2405aa05060869b25ae487561885c1512f552"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/v3/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"

    generate_completions_from_executable(bin/"mdz", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
