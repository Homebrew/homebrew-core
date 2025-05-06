class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a7b886cec0a60d8c3c80f741269fd73e6022f09581c07dffad8d695f44d8d153"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8603cddee2269c2336e148ba060abe7017172345c2f36ddee38ed5c3d8aeaaf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89fce0e69b4ff1263e047fdaa785d0088ee64b1c936f043e328a1e6dfdb88e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24951c62de3eae38a010d5a41380524ec3eef56dc26846437c6e4a71c3b07578"
    sha256 cellar: :any_skip_relocation, sonoma:        "164c7913c7ee1f24960a0df7483c14111567b9bf69d373893de60544de1c654b"
    sha256 cellar: :any_skip_relocation, ventura:       "a17a0659ab28f7a7df3ce59dfb7a24f604efa6554e5dde778f2ab490f102b1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384556000af0673883e23be60727257d87c597cb6c337675f5c3b015c971ee4a"
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
