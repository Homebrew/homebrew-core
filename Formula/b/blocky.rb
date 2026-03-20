class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "4f384230965c3cf9a6cd977e2c28cfb711e1e383f9d022c78295cf896ecf9bed"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aae4b193ea5f8a18fde101faeba0ae14411cca6a47195090bd3a26d8f49afa48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "320afab4f30f575ee3c2de9c63e0f62e70d0991f835b01adbc02de36666f204b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c608958f383919c38a5a578ba1478f31eaabb8eaba921253e08238959c9705"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfc14fb077737658e9bcbf37a01780358c3207b4a97382398148829fd420c86d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3395e62f6b3751b066583d61b8fbbf4ef07266529780a3c34920383e77236c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8306ee682957dcb06faf9825e3c34b188de22b4a7da043453682da6ceeb76b53"
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
