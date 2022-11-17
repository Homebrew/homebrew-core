class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/2.0.2.tar.gz"
  sha256 "74125750452c751ec62966d0bea8646b2f8d883095892d3dad641ff65df6bf9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53baeb4480be481ee214d7999ec81103af8e4bf17c35538da47f5a044000294c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a783f4261bfd14a620550e7676dfa45ef7ea840175591948d1fa6ade1fb0d2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a783f4261bfd14a620550e7676dfa45ef7ea840175591948d1fa6ade1fb0d2a"
    sha256 cellar: :any_skip_relocation, ventura:        "509b219ef6d167a4d74fb8f3cc1d5f204a659831d46840c2138ac5c601a418e4"
    sha256 cellar: :any_skip_relocation, monterey:       "c1260aa580c7499faec17a305e2e1667843a3c71fa5e93601b579c2c13eb789f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1260aa580c7499faec17a305e2e1667843a3c71fa5e93601b579c2c13eb789f"
    sha256 cellar: :any_skip_relocation, catalina:       "c1260aa580c7499faec17a305e2e1667843a3c71fa5e93601b579c2c13eb789f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb55ed63e1324d556cb9cfffebd3001460b23e455fa9c4c3f5d591ff3306b856"
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
