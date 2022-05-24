class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.3.0.tar.gz"
  sha256 "e874a119d13244a430e3f2353209d84f93feb6bf1e30f77d7c360d8a6d652bf1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2393f19273d615e30094e977971d68a9bdf9bc54cb537a9425026ad5763ad10a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f0c24ed6028086b7236c8a1bde09538766874d386eb60ffbe63aba75f61a4ca"
    sha256 cellar: :any_skip_relocation, monterey:       "049f891f1418410463fd669eb5cf413b050bf66765b61f76866846ee56a1511a"
    sha256 cellar: :any_skip_relocation, big_sur:        "16b7fa3ffd1135b46ce6074a0c9d2eed356e640c6d7bbf3a25f92a5cb03bc205"
    sha256 cellar: :any_skip_relocation, catalina:       "ba726a496ffda07fe32a4de0dae7277492b8e4d020f0d74681e657373f460cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3ccae88b16b3023a229e9473e13bf12a354c9d8e22f99852524064c81e89e2"
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
