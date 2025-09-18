class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "28ce4a3d73e6eacef81bbfd2036eba5e66c4f18d4033af48832c5f69895a8a2d"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fde7b076d140ac1eeffa99ad93845cd0630362bcd35c9adff00d04fe6a89d290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391e947af99077cfc2afcf59086377eb3c190f24511a3ae9b67158d205da44ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "227a22265e4ab72feee92e795fd68ce519c36464007109c968c40b58925f6810"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abddffd7451d432e5b809b35c73d8a51bd64ec648c43d6ae958d9e33fb0dbb15"
    sha256 cellar: :any_skip_relocation, sonoma:        "864de6535e6aaf34cfdfc83f2b6fa1f70fb67f439b1945752d162db0e77483ae"
    sha256 cellar: :any_skip_relocation, ventura:       "24526c3700a395d77546fd55d4bdc96c34258b422ea24e50243be6b387494fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed1f8118ff4547210910c314e92dde9902cf4ecf66ab11e0ae73a2c67eec650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93dd257910558fd02f18a98af0adcf6246273cc34d5a03e822352f66847c87b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
