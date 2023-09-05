class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.22.tar.gz"
  sha256 "c11a4532ad6636d120ceab844af1a846a8fc379acb03359870de1dc1f8cf7876"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceb87fda46e3057ae4eea081550af696261c26877a26b0b31c9836749ae41d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b2df2b8076f1e6c80ea9faa1f16acc29d6a395d1c9afe768d90cbe6fbbe663b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c207eff57a676cadbafa8d08305d6e7bfda175375902427860c7646a86572921"
    sha256 cellar: :any_skip_relocation, ventura:        "f5e713ef13914171c3739626f339ba37f07fb8ff1a6af851c79229d9fb6c4e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "8ca5fb2eb707fd6a5641bc8d91e5988efe113cd86ed11c903e32d7ed27fe7508"
    sha256 cellar: :any_skip_relocation, big_sur:        "47a60e4f8236181e987b3463a1b581fd79fff883b63174a076115ce4f283b224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fabe0b2da8814a014a9e228980afa2c6155c53f2189c05f4a4d0e98122f89e33"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"
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
