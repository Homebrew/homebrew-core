class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "0cf3bc3f6d29866a057e3619fdba3a247cac3631fe3ee098e0e063bcd6d081ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abd1a64bd16018bb1572e097e5dc9e4b36ead9296e8ef2bc15ed311056d7038d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abd1a64bd16018bb1572e097e5dc9e4b36ead9296e8ef2bc15ed311056d7038d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abd1a64bd16018bb1572e097e5dc9e4b36ead9296e8ef2bc15ed311056d7038d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd52f7754420eaff42db0893c2b0ee0406bccfd069a9fd871dba6fa6114d3ecc"
    sha256 cellar: :any_skip_relocation, ventura:       "bd52f7754420eaff42db0893c2b0ee0406bccfd069a9fd871dba6fa6114d3ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d03081ff14fb4eb65c0a86f275a176cb1d3bc85047d2a2606ea9dc25b3c6721"
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
