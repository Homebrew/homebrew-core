class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.5.0.tar.gz"
  sha256 "273e35b5c83923b21ea09cbe1b7d5a8ed58e62a17565d1f6b37bb5d1034deb9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbd0803944a3bf29797aed9c4bfe9e1f81a1e492aa13c28704611fe97d935af0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7031a7c18e82336d7d43b30f726193092b01969a50155a3f5b39efd090ae6cf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c3d0ddbf7cea4795f770b088edd3353c88ea462efb9f6c48ba9f57d3ac8f33f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb5616d77b7e632e6937a8e788fb4577a64be5da2194bc140504ab3f4833c9c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "12ba3f34aed34a32028b600697a7ffac6a34475122b424f6f733c131282de72f"
    sha256 cellar: :any_skip_relocation, ventura:        "fd6039539880414d746650a57545d2ec325fd7ed04f2cc0af32057f44ece8b66"
    sha256 cellar: :any_skip_relocation, monterey:       "5552a13143bec98d81d4b9358be10266b5b350cb22d4a1006fa1aaa5687678a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "979f2e49fe74ccc11da42ac9687ed2d79e266a2d458b45b1ec7f873427367a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3416a095de4ee0a7aed417fcf74225a1369729e5f80ad62a24f4153b1e8da07a"
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
