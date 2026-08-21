class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "6438c5d04877feac4f41ab1e0306111c93598f386eb03e79ff21627d3f1ac12a"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaca59d1ac4f155657ddd215852718d237e80ebe43e8e85251b8c6e6f91b2b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f47784a16ab752ec40fdc97d75de674d11521c9c4a5a91c19d2bcc477e2633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92794e98d2b6c3e2c47cf9f058ab7f00cef0ea6bc062022090f9bb30f0b0c56e"
    sha256 cellar: :any_skip_relocation, sonoma:        "74711118361513a0bc753faf5a9af878b2586c34f662118eb8bd1b1d7dfcc47c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50a8d8b1b87fe4095a42843117b1ac49ee36e3c568746d9235e6761304b75b3"
    sha256 cellar: :any,                 x86_64_linux:  "849ffe2c4ad2aa9b0052c429912bbbea2e0536078a5886862f84adfcfa925a54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
