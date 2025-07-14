class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "c9406dcccd2fc7b306cd251370bcc2b0e42e54e7a336df2762ea667d76633f54"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3939c4923a695fd5e43faa02a7a31ce25c19a1d7b13fcf551e4410ea9e7ea4f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "043dc8846b3f44a0953ff390b877b438764be28931fde8b34c3abeee737ba320"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620db76749f92ebd4a3e85382f54aa1cf4e55a73dbad6cec156cf59a7ac73790"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e14402c501b864aaf6f28c5668a70887aaa1053992d6e61b6006c93e6fa2ea"
    sha256 cellar: :any_skip_relocation, ventura:       "84732e1c15e5a82e760d932f2ff93e649b60c214ef542918a37a0a05dfee7e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb91aea455c8710fc6791026a2957bd1f095611b2e68477d8151bbd33c7cc372"
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
