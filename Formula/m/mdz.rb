class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "90dd73587171517ca5bf2130c7e882c7e4fbf740a1d7343a2686f770e2d71b35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adea7854ee759c88cba67047000792e004b0b4e78236399d9f9d247db237c176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adea7854ee759c88cba67047000792e004b0b4e78236399d9f9d247db237c176"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adea7854ee759c88cba67047000792e004b0b4e78236399d9f9d247db237c176"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb6cd529df7fc9a3e1ae4a0590128aa1f49164ddebef71a1f579fbd4e7eb0cc"
    sha256 cellar: :any_skip_relocation, ventura:       "abb6cd529df7fc9a3e1ae4a0590128aa1f49164ddebef71a1f579fbd4e7eb0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14c9301c95032fc132bca57f1271ad9cb8a199860c87066305cb784ffed2e348"
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
