class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.3.6.tar.gz"
  sha256 "3b649c6d45986dfd6d098f07281040a0efb479265e365263cec80725feda5cda"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6b502ce6aa976fb5596e57b3b1fc378bc7e6fcf68112b4c2fcff0db7ce2e61d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa9a3cfa02a6c8075e43692af6fce96ab34ae3de61ebd9d9a49872efd711dfa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6127718590325e3c0b4a35b3dac4a392d89929e51a0d2271430197de4d1d750"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbce075c6c026b9e5a155b31c550c5a71ad691b0490768e0af6d01337cba7640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac85ba558fbae2893afbf579a9a4827dd9f017e16876aadc9220d6ec71e8825d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab7e3db07de88789c5511c5dd6c804f779b9667b6f47c3bc379bb7c185e68fb"
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
