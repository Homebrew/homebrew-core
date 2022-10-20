class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.4.0.tar.gz"
  sha256 "51be97c79e071b8449ea189b507527a59ace364d8bf63f334305d6152bcfd9ee"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "752c096961faf8b18457bdc42c8f470dceafdf36da7134936b912747423a4a61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ade3697ff2a7776a2dbf262c07a57792fb7e2a7441451ea29895c7ece6f88915"
    sha256 cellar: :any_skip_relocation, monterey:       "29c82da68bbf580b952b72472dcf550b11bdda21c2a9bc8903a1548f4dd65a04"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f34591112b1c9644e88b1d7f289b8b35da07f28db09f816ca49fc8f126d0a12"
    sha256 cellar: :any_skip_relocation, catalina:       "a5ee978a20f23b503ed69280f7e5966164c7f189fa7c3b33137cd3f3d5f5a94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4518f7ce6a12a39c23999d4cab2249668457729f4ce61a98202f7c9c1f5c945"
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
