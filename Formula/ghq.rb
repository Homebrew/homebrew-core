require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.8.0.tar.gz"
  sha256 "e3df98794a423000676987812ded7dab30367dfbc82a2b7a8d2ebbea12fa81b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a5d83540ee47d24478c689f4bb2d525942d0f35272a7a71fb569cdf90c492c6" => :mojave
    sha256 "84dc071749a4a22165a58a48de193b9165cc08c02a0e817e097b662cb4ad5d41" => :high_sierra
    sha256 "ad05a023f52f11867a400d0109c98258ddce536728d4218e3694c836033a0c7b" => :sierra
    sha256 "fab4b2d64cd2b40e3b6045b145525e2a23fdfbad5b22ba37a28a85c909ee625d" => :el_capitan
    sha256 "d8281b077e388d55fdb8a2012c884b5195fe42be4bb67c14e0ea2a1c481f288f" => :yosemite
  end

  option "without-completions", "Disable zsh completions"

  depends_on "go" => :build

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "805cee6e0d43c72ba1d4e3275965ff41e0da068a"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/motemen/go-colorine" do
    url "https://github.com/motemen/go-colorine.git",
        :revision => "49ff36b8fa42db28092361cd20dcefd0b03b1472"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "f017f86fccc5a039a98f23311f34fdf78b014f78"
  end

  def install
    mkdir_p buildpath/"src/github.com/motemen/"
    ln_s buildpath, buildpath/"src/github.com/motemen/ghq"
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version=#{version}",
                          "-o", bin/"ghq"
    zsh_completion.install "zsh/_ghq" if build.with? "completions"
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
