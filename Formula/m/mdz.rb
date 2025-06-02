class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "67a8acfbf3df32effcb73495257ec499071589c2094ba5d29e4576ce74457d8c"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295b0dd5614208b7f400a010b9d4b8da9fa6d8b6fa92ba8aa786517b5b4d6e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f354d43debe30a22365fd2d31daadf20a7ab1a1b5e3b3de529d8c9fbad314f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00494a3d29be3c5afa74d0bc9674faccd29e0358260ef0cf1e316905da07fbf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad60b38715faf799a93d909d7d3db5997075e2b3049c517913a31bace81748f0"
    sha256 cellar: :any_skip_relocation, ventura:       "6924a972f36ccbfe48a88215e8e74e7db68e81cc9851368b19df94f889d053ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c467d4ec0bd584048544b804e232cede3f2f568ab36ee9dbfc4263c3c74401"
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
