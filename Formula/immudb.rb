class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.2.1.tar.gz"
  sha256 "b8e8efe5721ae7b2d2830be456765a58de2df4d5f12d3959e3df9765e4118e1b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0648960d0ddef5c115ff966a4d9a8dfdffcbcfccd409e80100034b89cf964859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0025a3eddd6b032e44a98a90bb4f639831399dd96675e7b13d514e0927edf3e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e1d55095eb1131f05070cc5f8844dec91ea2481a41ce1163dae72f83e5c87d2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8506c5849667a260bc3be00e4b6f762523425dd700be532317a15a9f15330917"
    sha256 cellar: :any_skip_relocation, catalina:       "639c873d1a07c3d83279a3ad73295a67d219df5685b3f2d1b94f694a2a2015f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ab9f7b80f55de34f8b737c005f28556f2c2cf1eff89259670ec5abf5cd9236"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immuadmin]
  end

  def post_install
    (var/"immudb").mkpath
  end

  service do
    run opt_bin/"immudb"
    keep_alive true
    error_log_path var/"log/immudb.log"
    log_path var/"log/immudb.log"
    working_dir var/"immudb"
  end

  test do
    port = free_port

    fork do
      exec bin/"immudb", "--port=#{port}"
    end
    sleep 3

    assert_match "immuclient", shell_output("#{bin}/immuclient version")
    assert_match "immuadmin", shell_output("#{bin}/immuadmin version")
  end
end
