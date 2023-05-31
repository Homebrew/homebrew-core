class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.3.2.tar.gz"
  sha256 "7df1932a885ecd20987db75ffe64cd4f1e91feec953ebaaaa23a21e5f9025574"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be18ecee6a29756d81f2cf10f05c5d06f1124a5a3707bffc6e54c3950e81f50f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be18ecee6a29756d81f2cf10f05c5d06f1124a5a3707bffc6e54c3950e81f50f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be18ecee6a29756d81f2cf10f05c5d06f1124a5a3707bffc6e54c3950e81f50f"
    sha256 cellar: :any_skip_relocation, ventura:        "b08b6be0be54b53d0aa44da13303e8434815c54ea9e7573160ba9df5932e517d"
    sha256 cellar: :any_skip_relocation, monterey:       "b08b6be0be54b53d0aa44da13303e8434815c54ea9e7573160ba9df5932e517d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b08b6be0be54b53d0aa44da13303e8434815c54ea9e7573160ba9df5932e517d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "859a08421bd6af9b1bad49581c12364458b0e3445a9ddbc83540d63e279ae5f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
