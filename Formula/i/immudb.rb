class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "9d4cebe7fa2885580e0ec4bdbf3c5ef45dd543c1d473a984f64d56c7267dac5e"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4300cf99338ded37a48e18b7f74cf9d6daa5562cbc20036974ae12ea880ade31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "790c0a00614c1859a83a1325a2dd6662a27ff189f9da9b6b0a0bc325cbe8c30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e458ce5f1316c60e052c38e03cecfa03047ff58452a702ae08045855ef149b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e465242e3b6e022736169825a4cbc6ce406e86ff0f22fce6dfb00be3ba17205d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72b8c1b3030311d3785f6d9e24391587032dd1d6b72a7e8f9728ea16537276e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eead8985b03cddf254c7d32497952fd3291859d1fa61e6f783b84a12d8e3091d"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, "completion")
    end

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
