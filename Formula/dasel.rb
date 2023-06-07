class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.3.4.tar.gz"
  sha256 "7c9a2f41d02f4d1717dcf0d9fb4b977308da89c074d2abcf064adf00980e5d0d"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185fffa565d45fe22ca6c85835d831cbdfb846e8478315e5a6047d8e8761dfe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "185fffa565d45fe22ca6c85835d831cbdfb846e8478315e5a6047d8e8761dfe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "185fffa565d45fe22ca6c85835d831cbdfb846e8478315e5a6047d8e8761dfe5"
    sha256 cellar: :any_skip_relocation, ventura:        "3bc2dbe89d7a51b642539c6be08604839d971fdef0a0a381a13a762f5f92f958"
    sha256 cellar: :any_skip_relocation, monterey:       "3bc2dbe89d7a51b642539c6be08604839d971fdef0a0a381a13a762f5f92f958"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bc2dbe89d7a51b642539c6be08604839d971fdef0a0a381a13a762f5f92f958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "863be6e1bce5d0fe6f87689dbcba5e3df2b8c10a192b6a6ed7c616d3d9afa24d"
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
