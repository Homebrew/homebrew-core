class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.24.0.tar.gz"
  sha256 "ab8e8433a6a72f842f83868940e3010755fd2572f83288a2f4a81b50bb7a92e3"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b9f472375d1732e6ee2ea9d303d333b5d349ad3af9413ed8a7fd8ad5be7547"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ea2bdf73b702472c4bf98bb57ec97ae0881301e8f59f5222c4cd770814e5fe"
    sha256 cellar: :any_skip_relocation, monterey:       "84fe181ba9649f7a635fa8f4897032db8479b6e51482aaaa177005add4899fbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "964530c9b952327840e5f38c07622426bbccc4a1cc567f53158e42742178bf7a"
    sha256 cellar: :any_skip_relocation, catalina:       "1f6d8c7c491e3f20093ee6141224ddce98def20280241fae7ef16930b0f859e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a4cb209378a92fad5a363a3f8d73a6ba311d45abcf561a77737bf55f42fd70"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
