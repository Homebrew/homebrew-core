class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "8c2928b2983dbe256dee04ff9649b80a440b032bf3aa23a60b6f902bcbfb7186"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "866051aa53f9e2b6f9476e1c8ccdabce438e9abb36a980953fa4576275d12a58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2503c9831f3773b8e5ef95fb724ca16bd505e6bec0c2b8b29811708a9ad86307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e6f32390fb89d1bf296e4effd02070bdcf468b53a71ff4995fb29f99a48205"
    sha256 cellar: :any_skip_relocation, sonoma:         "f467b30b7fcc94ed4a49721f52bdc4242c1824893152785784d1c44172dbda4e"
    sha256 cellar: :any_skip_relocation, ventura:        "57c35b51f5dde1809566f05ae7902f37dc7bae27e39f436ad32b443f38c15bb6"
    sha256 cellar: :any_skip_relocation, monterey:       "2b61c1dbd480766f6a88aa86095fceb8280eaf68f5a69472b814f2dc466e4b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d366f6b97207346ed099cf8cfd994919fb60492a283fe988abdfc0ee35f48e"
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
