class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.4.tar.gz"
  sha256 "15917cd454402d4289a562740b0bddb8dfb4039f144563ac9067d4d4fd619717"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4623879f968654906c9c53e73f468a1b3e3387869d125eb221006ec7343eeac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79fda3b2ace38d1ec0fb152f3ca23b55766739a27a25baa0dfa217b751138b30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1625280d90894c36cedfb597652723a2daa09c14ebdc43ac159fba9e77530d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f8549eeef5a233d82e342bc9c1cc4996af927985335886ff3b539d9975597f"
    sha256 cellar: :any_skip_relocation, monterey:       "78745c27ff6c0795b30747f7962d3627de041008ddde37e1bca60dc81c34abad"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3040cbd2790faf2a09d5e799a6110d15068bb7735f31cebf5abb4554d43ee13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfe11c84fd73588f9d649a19e7235ca39d86cab832c1a327b96be72d8884fdcd"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
