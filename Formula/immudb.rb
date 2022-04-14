class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.2.3.tar.gz"
  sha256 "9ac11c3a34ff5d438867aed811bc00bec03e27b746908dbed87a44d69b7bc7e4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4058dbcf9ad539dffa3233c1011e60fe42fe663d1945921a1a25bc521e33b6f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad07b54822ae7fd4ea1f6e75d813513b5e6cbddba71ac6ce625528abf604cf98"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d1988a3e8609ebd6e0a2199ff7f6257d32b58818497403a8a7516dce8d477b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b2da7f36c75d8ccf86286e810ce65bf8c51a08a2865e48dc777cf4b1a5aeb4f"
    sha256 cellar: :any_skip_relocation, catalina:       "c473c5b400625b33e1740ffc4ca6a8a5efabb84f373f0463bc8f0971a91a8767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca747d1e87572ad7e58a9d67289e6a69d72da32d3d7e88c2d8f29b51b438d0a"
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
