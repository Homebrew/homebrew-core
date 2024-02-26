class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.9DOM.0.tar.gz"
  version "1.9.0"
  sha256 "62d2638cf2e7005045441e7c44457dd6686714b85b54be98c1460c228f4ddc94"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4868d088f7b84a0f9d01676d3534a7f2a127da182aa6a17208a29e8e4dbc462e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3e16ef882d0f581a4ff4cef7b266472ef56b971141e0717d2a27e05a5ca1bf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f014f55b7f4982482a5863b0ebb613d89dbfa759b1ecdb075c52d160854d724"
    sha256 cellar: :any_skip_relocation, sonoma:         "b23bda5c964fb82bf55d3f225cb819ec020aef411e75e89336e2f0a2110e43d1"
    sha256 cellar: :any_skip_relocation, ventura:        "943458682676d00c9c77cd3dedbdfa5accb4987c0b1d556be62a2ca2bc9eb968"
    sha256 cellar: :any_skip_relocation, monterey:       "74f574f6eb18f5d4d23eaf5abd1951b555d6df10d88cdcc18812b284df4c3423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1637ecfcd2ab18cb9571e104d27d57b3544527f6a497c6675bad47f1032de2cc"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, "completion", base_name: binary)
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
