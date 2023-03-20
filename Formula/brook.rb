class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20230401.tar.gz"
  sha256 "332069845b9c205070c0edbddc9e0204187499b97d4d1bda593535d775f556a3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b54b11c4d6e83af4310c93b218cdac7c771ac54a556de7754e11d33fcf7b9e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bb171fd1e9bf2e995263e15e59eb01950d8a3f511473729fd57b00ecbae909d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cd5f5f504ba6e52a396fb52f8cc953a16b92e76eb16f8104ef425f6e94ddc08"
    sha256 cellar: :any_skip_relocation, ventura:        "758f367314f35ebaad5a48b85612fe627f594f539e4c6606ffe6a7033c865099"
    sha256 cellar: :any_skip_relocation, monterey:       "ed68033602dcc526db5d2c8015f490a1fdb25fb09f50e2fa8bb0f454a50b9fa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "18beae64fbf4555c5514dec09eb06db58ec518a84bead6f878b75003a4faa3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa63dddd70b980d7e3e1d1783d88e08928f9ee762260ee9020317e021fba9e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789"
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
  end
end
