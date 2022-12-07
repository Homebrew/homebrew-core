class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.0.1.tar.gz"
  sha256 "259746d844ee11d15a76b8c6e143572a5fd0b233e3e19b70b78694179a33d0fc"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64c7a75c009392ba376161524c6ff9c907561f22db00a47f1733b6e29694fec4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13001f88da27a747c4d2a9fe4e81a254a7a34c7e6674d5a00729c9fa804c048c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eac07f1095675cd0717217ba8b00e1acc0a4e0f3fba90b48c25add574c83fc63"
    sha256 cellar: :any_skip_relocation, ventura:        "2bca69a60f78e0e5c36222da0d59b154814a3ca242677a0237d450897b3f8ed0"
    sha256 cellar: :any_skip_relocation, monterey:       "58292178fba3ff15bd0ee97330c91615f76e315e126aeecbcda261b10e562c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab75ac8479400019081cc5533fc32fc9e9352f823aa581e6f7197526848723aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a63880a27fc183f18aeefb41e0ddda79bc475a7c89941c0629820b2c9898d95"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
