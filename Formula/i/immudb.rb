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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57adcb7a7632dec66da3c2b4e3fa7ce595792344cf56184945fa2b6c43f9c5d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b86bfdee9da2132bd163a915ff854fddf0ae4088456896a1c68236f4ae14e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70cad33673c8782eff8c6be315a0369b032136bb8ce4533419e2b7ef924144fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "757fcfe0a1ae956a994ecd3bfdcfa2d625c821d8fb3acbcbc242594a56c02710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d5c3ca6b77702e93cda0ac7b5df13097fdd7e7f80f8c94a30a468ea7056c049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e7341bd110bd04d6d3cbaa92c723df5108b3ba65893e1882b420fd714af05d"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, shell_parameter_format: :cobra)
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

    spawn bin/"immudb", "--port=#{port}"
    sleep 3

    assert_match "immuclient", shell_output("#{bin}/immuclient version")
    assert_match "immuadmin", shell_output("#{bin}/immuadmin version")
  end
end
