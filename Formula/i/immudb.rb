class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "0ef5973544d55cdf6253f9150fdffc0ee6e741ec85ae659d87b5304fe8ac8660"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c058538f7307b5872a79ffcdc56d98418ff0f3caf08cf3bf92780f25db1d4c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7c78a815a7c0bb015ad93aecd8f7cb7d4b30654d16a93834bcadbdf398a3fa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c83510b23742af6f9218948412f67807d6389ac32ae2d6d7cf095b747005d8fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58d20894465de1ca48b94b2aae0ab7d7c066563cc8dbe47b8a9f82ae65e9402"
    sha256 cellar: :any_skip_relocation, ventura:       "9dd0672ac48f89c156e7b9761adec55558d3da501ec2f145a4623a7e0cd71e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516f2190467d3e4034564ad637cd3831ca7bb23eaf2d35da79253b218ad64758"
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
