class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.1.1.tar.gz"
  sha256 "2cbf72eaa81989bcd8b8db441f06f54ff5ad8beac87cf2f0793d26324fa462eb"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6712f9a98d409da0c457a62c9a46a7240f4d3013a32f14de1dd9a6d3253151b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "967a28a9aef93e4de9fb70fef81cb64eb5851636fd91112d5bda3b1c66ffd588"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78d5108c234f7951c6ff0ec2d00d13eb9dd70a5a80c6d153133cb27c3307c568"
    sha256 cellar: :any_skip_relocation, ventura:        "3da3194a50f113a64a959c43d575d0e784a71e5b1deef52e5aa1f81755ae0e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "22368b00af32b9e1ac1b656660ae266fd464678e59e68356e88c213a69fd8c30"
    sha256 cellar: :any_skip_relocation, big_sur:        "3341c7ba5e798a1e67f7aa89f99f31381e961d2fbe5450bb1dd483a1515ed925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c538421579e158ebf76c06ba913dcab4d55c2f0c5934d2354a945f20f7430bf2"
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
