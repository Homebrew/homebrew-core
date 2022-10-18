class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.27.3.tar.gz"
  sha256 "1dfd0bf372ab252931adc636887c1d34a75e9ac767b5e6baabf9fd91fdfa15a6"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b039aec39b59468530072650b74b8fa1f167caf23ae5294bf94fa75249a22c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ebf1f0a99009cbcca8a838e6b9952bba6d822287e75616289222489e62e0a1"
    sha256 cellar: :any_skip_relocation, monterey:       "2179e1f2d3503c63b9b5476295256144d62b68b67b6ecbd1f2976916e89b409f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe21369adeb176dc31df9b09771b108e7a09258b26a2e11e3f7f109e3863c729"
    sha256 cellar: :any_skip_relocation, catalina:       "13eda97e3957681bbc74d655975dadaf595f6ce21e1411814d92761ae68538d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ccacf71cd8e0a2b4dfacf2b07b61f4f73c8921138afc5f9c47a1c6d3f72b47"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
