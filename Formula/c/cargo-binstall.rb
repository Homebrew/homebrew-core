class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "0a41e12770fd2ed00704d7d9d01e001c11e5f3c9151803730d96a54eb2805d6d"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "678efa71751eb305a9e3cc58dcf584d61d5ebf161e8fcd5467548f3e39c370ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e3b8eff4869bbb64c61198af31255b900c05557db24f5bbee52b36fcab798d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8f2f8f1a77fb38f00eb9a6d4ea25836ae7e81de0db0f10c55e23c4a6832a85"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8e7c0dc3e11aa5dd4ff3b4fc4c07f7e8ccb399c1b251e60b738f35651eaf919"
    sha256 cellar: :any_skip_relocation, ventura:        "5de76c02bcba36e198c8d60c109eb51476c21a93299629feb521c9066f7e28a6"
    sha256 cellar: :any_skip_relocation, monterey:       "24545523e26c4600fa5707023e14503d11f849d6edbd615e33304aab36f595d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8597e9088a819df9662aab1826f3019c7dd63c7e166b6aeb4539ac565740c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
