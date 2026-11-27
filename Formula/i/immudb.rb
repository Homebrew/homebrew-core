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
    manifest_sha256 "c101b0dabd63dce94b2c0b01abeb97bebbb316d4b9499a1125759e94020c8f6b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eeaec8edfdd9db3febe7b830201eee1155faa5db6c6ce9967aea644422966ebf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d8840cd97fa44c50e6c7fbf4ddb0ffc0ea749168bd6839eb9c1eea1bb75fae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de011e6e75a0c34a72039ec222b651e3508512926859b89114de3736f855c38c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f95a30f08f2a44214097f25d6398fe99f733eb82f64fd1a2a3f4b91dbde6a8f8"
    sha256 cellar: :any,                 x86_64_linux:      "b06c107b964b20d042a5deef729cf4852533d29439e2541900da41f4aeaa5afa"
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
