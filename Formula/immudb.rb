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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e45fe41e2a52959f84f48885a1453cd5ccae904e9ea66a48e9f78bca583ed0a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a313198b4b4d8a91c1777774706ce5269a809535e31cf81ffb26337bf37908fa"
    sha256 cellar: :any_skip_relocation, monterey:       "6d42e5861663810fc2cedd6d1acb01ffcfe9cc27d5ce0d0fd6b313de11affb58"
    sha256 cellar: :any_skip_relocation, big_sur:        "262dedfc11afa53c5d6d61e5ee81f08d17e6426681cb7854b8ac3f3695cb8c12"
    sha256 cellar: :any_skip_relocation, catalina:       "c9aca23e4d1518ff66da5a833400de34fd00956800c2b2a81891c86d97c94078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b993d90c4e0958dc8307c2ee88ccfa08c589a0367e9b8e45f6af16368e92f40a"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
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
