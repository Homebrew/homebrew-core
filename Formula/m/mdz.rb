class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "fad51d7c1a54e758f7010f72d08e353066575ba6fdf590ad3ed97ba24db97f4a"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb1caa8e2f2f7b9619f85c44ac7df02738f63ffaab443a4c57f4456fffc13c72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef09644f2496244d3085bc6ab702f4bc750b865a4485ea99a715e2d911cf8c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb9938f3646dabf215c65c91082e623fb943ab2e3ee788d04e04d6e296e50481"
    sha256 cellar: :any_skip_relocation, sonoma:        "5da1d0253f23182630eb52a6190f2c62773b6837492382b75377809604150775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70fbef414acfd8dbf1c1e2b447171873dd57fadfcd12ec85dc0672d3d48529e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9005038b7b2fe60d23c94a042f59a075e49f2c36ed689e07417266f8cace9e99"
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
