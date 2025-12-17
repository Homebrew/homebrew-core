class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "ee4d8073f040a1cf182eb05ced0f0540b6a70ffd49187be3ed80c8f1290c37a3"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cabd6f40da7d2b4207224112e732f913f3d5968e3e975360f8d163b787f389c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cabd6f40da7d2b4207224112e732f913f3d5968e3e975360f8d163b787f389c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cabd6f40da7d2b4207224112e732f913f3d5968e3e975360f8d163b787f389c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e8c24cad82c5cbfecff11a26fcf76edb0beba5e195fbded2ab00b325bae1988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "373c8cc51278150ce3c0f23cfef5c99c37385d8192b2f0cf4a13fda8b354b2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2898c5a8e305c7dbc8a0069d41737dff0b1d2e0fd56edc30994cdcfc666edf3e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -i json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
