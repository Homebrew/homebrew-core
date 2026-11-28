class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "08d31dece90e219f306ab969256b358c7ad353c5166d811c971b6cdb4c447446"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e10bd0b97a2dca639e96ba53a6979524db297946e602fd17252b28cbde849552"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f36d6a03ab665298f90562f4ef456c14b2f1d3b27d22240b3e5a910a6a4f4ce0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8ddc310a38122ae96c3e096813eddedde8da8b18f71f1556432a98ff90d5047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc464aa990ee42d88b0a6362f84729c4672651c016d8f4972fa98b1c884eb6d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "509d5577e9fe388ba88af0b9f9aee7b2ba94f619dee143f0f0749dc52fa77202"
    sha256 cellar: :any,                 x86_64_linux:      "f6efa8b498ed40e4ad73aad4c3317c39b4da398aedfa3683591c076a3b938a46"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, shell_parameter_format: :cobra)
    end
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
