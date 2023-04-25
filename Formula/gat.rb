class Gat < Formula
  desc "🐱 cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "9e3b24f739581af9cf37323d28cd0ec1790c97b40c6a4212b9c4358465aee385"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b69a1e8b2f4519a7d59dc72db3e9adbfb4a601cce72c8782bf02370e146534d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69a1e8b2f4519a7d59dc72db3e9adbfb4a601cce72c8782bf02370e146534d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69a1e8b2f4519a7d59dc72db3e9adbfb4a601cce72c8782bf02370e146534d3"
    sha256 cellar: :any_skip_relocation, ventura:        "1232c9c7a48665af66e5900a7b66968fc77344fe76d4b2f5432c46820494d0a6"
    sha256 cellar: :any_skip_relocation, monterey:       "1232c9c7a48665af66e5900a7b66968fc77344fe76d4b2f5432c46820494d0a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1232c9c7a48665af66e5900a7b66968fc77344fe76d4b2f5432c46820494d0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd8837f4b4365c00281c603507b52989c6dee582526c72ddd5e4e0791a7a0de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
