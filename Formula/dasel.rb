class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.1.0.tar.gz"
  sha256 "597d5ab3118eb5bd41859a9b134ebaf18855bba3b20f399c7202a2f132563662"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8172f9a7cffbb85e555a7ce1ad7438811bb02245b60ce81d8d9a56bfce03aefa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f14959b1309c3f23adfd98869cc81f6f940f18ad53965420836b354144e7566d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0615a5778f3b002f873414c1a473b17331650ba58024867cc98d9236c63e432f"
    sha256 cellar: :any_skip_relocation, ventura:        "92abec79e65e8e5937af77b7cc01aefd55bf5b8c1827c32d4e9e7b33ea5055e5"
    sha256 cellar: :any_skip_relocation, monterey:       "e75a0c47a5961195181615277dd07255751fcfe076581a90738a165c8e281665"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a0734a147745e54140c7de4317fc5c267bc0b03bd475f149781a6ee1bcca42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad4b3eab532ea6a147ce7fbe518b18887894c627881269954ecdec60f3f0cb3"
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
