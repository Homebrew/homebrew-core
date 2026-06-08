class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "faceaa12500446dd2752f1f6640d1189ee26beb348ee8f119c2f873a4f095033"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6f2e5ec81e20af3632c77bb949ba902afc8e3e9897aee346cfa509219170f6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "381225d70b8394ad2be5ec514b0053f57717f4219085943e98c6bd46129bddd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd173f1e4101f13cee2e0cc1c772eb8499da5813282092f3d27794ec6bc01357"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f946df653b5708881dc3f4b8f9f797c465d8f5199015b030880b938736dfd1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773373693bef6c2048a61f3e0cf2b4cee43c01a5fd8df33881adf15ee9ec3a4f"
    sha256 cellar: :any,                 x86_64_linux:  "2b4f3be1db77e123977f3a6c223556289854af1c277baa095f21911874ed2ae5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"

    generate_completions_from_executable(sbin/"blocky", shell_parameter_format: :cobra)
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end
