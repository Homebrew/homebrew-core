class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.0.1.tar.gz"
  sha256 "eea603c631eeba83019037082ddf7f928c289160537358be94d17c7f9a56d297"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2388944b434b6c652a89beaa014614d7c83ed6f315710af7f391ee66f36a8966"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf6acf2e01e7e1151094f973e110e90b2eedb205ab18e1aa98ca3870a5ecfec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e85cfa10631c4850311414c6ebaa812c92b103555d04a2e519e037af9d70437c"
    sha256 cellar: :any_skip_relocation, ventura:        "450100d5a49df5d0f160b9c5bd6597dbf39da75801d59cf22bb0e00fd503f90e"
    sha256 cellar: :any_skip_relocation, monterey:       "870439638bf54313c98e2b3d6cf688d696364b42a6fdcf952997396559640ca1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f5f97f3641df4094ba7533241cd1f48373b7044105698dd74fd48883ead1199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623b4a0b81aeda743425baca77ec21b6e4519d27cd0fa2548ff5fad70b140e46"
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
