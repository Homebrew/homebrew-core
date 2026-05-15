class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "ac07da5552f4d14a4d646059a633d48c7e9d668989c4522b8a9924f0c55286e0"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50d9b88b928c183aceecbfb26ef2a61f1d4d78841d7af7413ec2215fcd1bc7c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6efcde16ebe6efa951340e90f88cebd880313709baa5543586f4d79aaf41bcf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a58211a9ca3f8c55c12acbb1a7ae8f50ad5d88861a25b81724152ab6d8a27c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "727ad82cd0b9a890a9d1b02c1acfa76bc3ca1dd2e97d696f53277e1969516723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15e79ad8608c3241ca1fbf0ac6cb39cfc8be1a6c3313c284061d34430659a96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e405bf9a9557af00bc893301f8c7460584ace1b36d751cc65ac3263bc88eb3a8"
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
