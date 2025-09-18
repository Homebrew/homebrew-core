class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "53033664c1461e48cf430b64b43bce14c49b396f4b858b562609ac219095393d"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa0f6ecedb19cc289f747f3c2554457878652d80a053df7dc19b0d3bab624e9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c69e7134f0152042b54fa4957a752097873234f6311d78088d3ba67db9aaadf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f84fa033eda281b17a78923aadbfa09b588fbd4db6fc101e1f05edc413adae2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d2aa02087ec6bb30bfe7e3b9c22d756227bdc0fb20116eaae84e4925627af6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c31ba641a79445f226a5543dd9d779f94be63b58427c9a8fa0e20e2ead7f1b"
    sha256 cellar: :any_skip_relocation, ventura:       "4f634ecb071e475a6700b698242909f83f79edb82797b65a9e53faf1af463389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7732f310bb2240a3ad9ccec544f59f296b2038892f1536976b373fee3f02475e"
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
