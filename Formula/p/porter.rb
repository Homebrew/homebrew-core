class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "eb5451b85e50e4033a50101171f8c6372ffd2600361bd34fa2d1166a8d062742"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5132b84b398bfa7cc1fcc82143d0dca926be611cd13180c33cd3708e7c73e5df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a77917b1ac5dca92cd823dc31a63763bfbf03640adb813642aa1eaebacff193f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2add51a382760271a7cec976bf34b3f9e596a70b98dfb9bb7b2b089898db2e93"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eb3135d2dd15c03051302285658430822eb16157d833257b48a27fc5ac84fdb"
    sha256 cellar: :any_skip_relocation, ventura:        "f5515c1f5876d71b62b3675313ad0db8f15aa01bba867f78d93b288708b9f10f"
    sha256 cellar: :any_skip_relocation, monterey:       "290d638c58363ed55db7839cde4b611ac4ec4e7ca1a3ad66ba5dedbbaf70f763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00ae7c88b62c0519bd245b0374555acd50542e884995915ba39919384629f536"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_predicate testpath/"porter.yaml", :exist?
  end
end
