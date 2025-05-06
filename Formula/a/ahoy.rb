class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://github.com/ahoy-cli/ahoy/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "934456f62143eb6dd92507e0144abbc3e3c0aa8a23955f89704f366b5df260f9"
  license "MIT"
  head "https://github.com/ahoy-cli/ahoy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c30c730a0e5e1e318913a11f22d2b0f93a2ec1805f3904c52880b8ca97f91e91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c30c730a0e5e1e318913a11f22d2b0f93a2ec1805f3904c52880b8ca97f91e91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c30c730a0e5e1e318913a11f22d2b0f93a2ec1805f3904c52880b8ca97f91e91"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e28243d18ab18c1e06bf60d62813ccfcdcacba549f43554b073cae907504ef"
    sha256 cellar: :any_skip_relocation, ventura:       "64e28243d18ab18c1e06bf60d62813ccfcdcacba549f43554b073cae907504ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "270832559acf6ca425aa07773609b8abd84f5e02bbf3fa8f7835a94076480eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2235499bed48ad1d1f2b57fef7fd9f83367dee64c64e4c603dea1f3063fe8962"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
    end
  end

  test do
    (testpath/".ahoy.yml").write <<~YAML
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    YAML
    assert_equal "Hello Homebrew!\n", shell_output("#{bin}/ahoy hello")

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
