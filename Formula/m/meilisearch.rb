class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.3.1.tar.gz"
  sha256 "42b71559c014c510412e94263404607e1bedbb4760f3688e35d1acc721cfc33a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4088667449035a9b549ef1c02d004c520b66d39716c39a12cee261b1b896f30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98b06911be9944c4f31085017e483224febbbbe1dd02fbf468c89b880eb912d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b8cfed81711a0c5fb94bc0792c711677ec52958ba7cfa1f94b3c7423a8c807a"
    sha256 cellar: :any_skip_relocation, ventura:        "340e5e85678f8422fd77fffaf4658b114f645e8cb98f9d37b854ccac0597bbd3"
    sha256 cellar: :any_skip_relocation, monterey:       "5f39d98a2d42931a5d40be488b99e849836f50912551faf451e2519acbb357e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1668aac389509c39aa167a9bd9b9b05508d76f6823e94057f8982088fab197dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39dc8801d081ef2143a8b6a3f1888f3f08d92509174e28100a7d86adab76c52c"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
