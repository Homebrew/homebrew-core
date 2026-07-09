class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.8.tar.gz"
  sha256 "5c0cb5d387c098e8cac4b27f7a7a41ef79e269133df858e72cc39aa5289d46af"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a1c03fc48b61199f901d75a4b134f8cdc1277fb4178a264618c2515b0524e61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea69452ef480ba56338872b9b54822b10a937714623b419c39f625edb967f514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c79d4e3a94f1fed2aefd1a26ea7fe662c11848a530eb0d5a534748133bfa01d"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a2670b5a05ea3680a71fe581c13970bc68538d5177fb68b0b1a7beba531bb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aa2bbede1274c606887b5f6b5dee1be081dcf13f0bf761a5961a491def7097c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df3007f6d42e420fbb28b893c09e219fedde0418df2a6d9612c4ca7e84c58e61"
  end

  deprecate! date: "2026-01-13", because: :unsupported
  disable! date: "2027-01-13", because: :unsupported

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/v#{version.major}/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"

    generate_completions_from_executable(bin/"mdz", shell_parameter_format: :cobra)
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
