class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.3.2.tar.gz"
  sha256 "e11862f5aad72f74d3a00480f57cfaaf103075ca0e86ca2d3f16d428c7d58edf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a0a7ded0ecefb90fbb45eac377e1407540d6e7da6b91ffb9abbec759547548"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c0a3dd56e8b011e8e42d813828c61ddd46c6f5203be05ff457c63bc7c745315"
    sha256 cellar: :any_skip_relocation, monterey:       "0e37e307fc0585bc9868876fe7e92d332a744aedbfffb1bd077b7924882669d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e59414b861d4766632688b6f33f98fd834933e90bfe317492ad51db04a94fdc"
    sha256 cellar: :any_skip_relocation, catalina:       "ce905a8dd1b841027cd2e79eff684af1e2b1207046f63a3f8ab3ed9c1903e532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b809adca6510ce7879397985ca33f8e1de676bb5453f594b0b753314cb2483"
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
