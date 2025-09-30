class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "3251f8796cf7eebf1c915aef95b78c20cd8b06dba958a96979356205a01e8f04"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e679481067dffbdf9bec78a80f0c261a069608c92822c4e173f4f81a01cb776f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0172d5cc80d8bafa7abe8c93f2fd891a0225b01c02e2243a32f63ad38abaf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9464dcfbabaefaf827b712653bf9fca62254bb2e3c9f527ccd2bbcccffbd9a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "895b976e41703a999ebca6dbcd21f336293335220a7c317f5c72f20d97b36e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309f87ae2e8b2e654beec57171f7310a4e9cbe734ee12c37ff72f744c8556656"
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
