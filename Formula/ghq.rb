require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.8.0.tar.gz"
  sha256 "e3df98794a423000676987812ded7dab30367dfbc82a2b7a8d2ebbea12fa81b2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "87b5fc1d352c8d96c10e605c92a2f56dcfb4357daa62d121b44df62e86e5426f" => :sierra
    sha256 "c44dbb258731843fde8fee860d0935ae184db1439f5de11464f70444c8db7464" => :el_capitan
    sha256 "2f59e9c8da2819b2a1d117352fc6d6e66e19a4ca4e31fa12bac955d57d7f5f17" => :yosemite
    sha256 "45bb6555ca33acfad9a9b0d8abe702dc1a2c3b07c4fd28e889acc8c952383022" => :mavericks
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
