class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v3.3.6.tar.gz"
  sha256 "3b649c6d45986dfd6d098f07281040a0efb479265e365263cec80725feda5cda"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff53c3bbecd6e24c949047a1f4a5839ead46576a6d13650daffd2b5a4ccddf31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ccf13d874921e97375a1e7422008d51e9bfc4477017b0d3af7edb2e8733e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84dee2b87123b6d8be558fe1cc93bf173bae6571f7599b8914fd9dc26d912154"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1d1651d056eb253a565e21299fd3d256817ca13134f851c588736f78401c351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ef81a0eda0c32851af5de06ddacce98666d023cdae6449b1e79936f2a6855e"
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
