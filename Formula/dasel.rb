class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.1.1.tar.gz"
  sha256 "2cbf72eaa81989bcd8b8db441f06f54ff5ad8beac87cf2f0793d26324fa462eb"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1da758c8a968e976273b0b11bec8f2be9d8a79c7f74a7d19e83155f2312caef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3602c480a16fa6a59ae83a883608c22988b1604ec2dfbd2e3fd822a479e45e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c96fac14a106a3b4fce74486355e16d6a4c2bf50873f1ad92d2019b41c157b3"
    sha256 cellar: :any_skip_relocation, ventura:        "f0792aa95caf2834ebd763269c0efff0968e5c55dd18706f136dbd8d8f94573a"
    sha256 cellar: :any_skip_relocation, monterey:       "b3b9bf49474db39c060cb4287770591d2a620931ef16412dc7ece847201e5a73"
    sha256 cellar: :any_skip_relocation, big_sur:        "381e0ecd3a0dd03b30a5013fbc55940cbfea5f5b7e2754a1d732089620c1327c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16e7d1e3b05f13398c883a937d6f0fd9e89abe029776beeab92bbf75cd9a621"
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
