class AhoyAT2 < Formula
  desc "Create shareable, self-documenting command-line tooling with simple YAML files"
  homepage "https://github.com/ahoy-cli/ahoy/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "e57f908df16c29d5e1b5e814496d0f9eb9e11a871ed68e1fd93aa286c557c540"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(output:  bin/"ahoy",
                                         ldflags: "-s -w -X main.version=#{version}-homebrew")
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
