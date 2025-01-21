class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://github.com/ahoy-cli/ahoy/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "d48b832a475fc9aa5ea42784ac77805afa7bcd477d919a603ec022c240a045df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0be876590907288aa7687f43dc47ca9b73a7927e85e94efd171e57ae1bd476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0be876590907288aa7687f43dc47ca9b73a7927e85e94efd171e57ae1bd476"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d0be876590907288aa7687f43dc47ca9b73a7927e85e94efd171e57ae1bd476"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be33eca2f4ea292d53fc0a2f177ef7bffb865ba53e52619568dcc261abcda00"
    sha256 cellar: :any_skip_relocation, ventura:       "2be33eca2f4ea292d53fc0a2f177ef7bffb865ba53e52619568dcc261abcda00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "739afb6f4249685b464784d2288c5c7d97976a76638096b01d40bd3cb0a14fa6"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
    end
    ohai "Please check the README in the repo (https://github.com/ahoy-cli/ahoy) for new features."
    ohai "An updated documentation website is coming soon."
  end

  test do
    (testpath/".ahoy.yml").write <<~YAML
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    YAML
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
