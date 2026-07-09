class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.9.tar.gz"
  sha256 "576abfe10fd74cf32b37d33faf4e1305c6d96e784941b5e5d4d78d8cb02bce7b"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e3b27de99a14284e973f0a4cfff0a96ecdf0004d69742d5eefe3b7f8d663fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00996937e7c87762f948d24f10ea83a152a8366c6bb800cda046beac1db4d52a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7a01bb180f042884b20bcfbbdf9be10c27c86291926e91af188ab7d038eaf90"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1d41d437dfdaf6aaa696bbb0c68449f5ab62063d4e316c1d3c56c28dd0ee04"
    sha256 cellar: :any,                 arm64_linux:   "8ae32b7e04aeb7a3bcd8b4587431640c781676dbf64c010cf9e70c284728947a"
    sha256 cellar: :any,                 x86_64_linux:  "a6806e0799b8b46085fb03f64f17822ed02c9102bca61f266695be1e3780aac6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
