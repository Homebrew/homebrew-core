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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97139315a3ab470c04d1021690088af8212867d85cd5731004a514f39f27590e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87e2bd8a2e8a5f3ffe5f70783978281498545c70bf632fa614d3ac261d98833a"
    sha256 cellar: :any_skip_relocation, monterey:       "15988eb0216ad85edda4130fdf33a7c7b19176d6af60138484c1aa0e1d990b6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "62e81659ab0ad5af8c6c1c5db2a31e887be8121267d1222d6e474e5a7a4055d0"
    sha256 cellar: :any_skip_relocation, catalina:       "ecc23dfdff28eca475818277847711387b548b1568be4015fa3452b63823a4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13aa5c9b96bf1e5741c5fe0ac6769a5bbdf80dce63ede3b78ca15ee2cb2d181"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, "completion")
    end
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
