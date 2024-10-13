class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "9131747774cbb6641b8f7104fd5fb239cbb6fe53656c74d2c29eb95d2db6f9f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3df3575f32c3f7f4b035763fb50c321691ee21a55cd09b0f1b7db7456e8b8a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff34fd831db681f141430674f747592b0d25b0fced2b7b06eca000904bd93c29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff34fd831db681f141430674f747592b0d25b0fced2b7b06eca000904bd93c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff34fd831db681f141430674f747592b0d25b0fced2b7b06eca000904bd93c29"
    sha256 cellar: :any_skip_relocation, sonoma:         "94456698ccb845385b3eecd9f567a51e763ce69f42b2c3cee43f23eb371a94e8"
    sha256 cellar: :any_skip_relocation, ventura:        "94456698ccb845385b3eecd9f567a51e763ce69f42b2c3cee43f23eb371a94e8"
    sha256 cellar: :any_skip_relocation, monterey:       "94456698ccb845385b3eecd9f567a51e763ce69f42b2c3cee43f23eb371a94e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cbaee24adf9c44204beec7e6b43d13a123aedc2be7e7382327630727a857700"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
  end

  def caveats
    <<~EOS
      ===== UPGRADING FROM 1.x TO 2.x =====

      If you are upgrading from ahoy 1.x, note that you'll
      need to upgrade your ahoyapi settings in your .ahoy.yml
      files to 'v2' instead of 'v1'.

      See other changes at:

      https://github.com/ahoy-cli/ahoy

    EOS
  end

  test do
    (testpath/".ahoy.yml").write <<~EOS
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    EOS
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
