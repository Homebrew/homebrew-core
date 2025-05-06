class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "23ffc0db0f09a76b5fbeb4ac99288eb710bb76328a62eebfd5b3c496a333b06f"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd161e153ab0079172f48878b3cb6e56a27ad41fb33aad546948bc0c4e1f6220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "055d9fddcf52d9050071be83495d66eecee43c8ef29cf0df7a47244d57601ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "464feab4bacebdaf0608b7a392e19bd16876560ada067051dbf745b0f8c3cc89"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c15a17ea8a351047e8c3b29dadf4faf7fc10e7c83289feb14359008c5326df8"
    sha256 cellar: :any_skip_relocation, ventura:       "49cb44d5e851ff03a054725bcacbe22a033e808986b9029bccf76569a77dbfa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca039e40556b1e10e3a923b8523e6dd1ca6956a03fdc9eba5a2c84e899a3652"
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
