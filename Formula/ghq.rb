require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"

  stable do
    url "https://github.com/motemen/ghq/archive/v0.7.4.tar.gz"
    sha256 "f6e79a7efec2cc11dd8489ae31619de85f15b588158d663256bc9fd45aca6a5d"

    go_resource "github.com/codegangsta/cli" do
      url "https://github.com/codegangsta/cli.git",
          :revision => "aca5b047ed14d17224157c3434ea93bf6cdaadee"
    end
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c44dbb258731843fde8fee860d0935ae184db1439f5de11464f70444c8db7464" => :el_capitan
    sha256 "2f59e9c8da2819b2a1d117352fc6d6e66e19a4ca4e31fa12bac955d57d7f5f17" => :yosemite
    sha256 "45bb6555ca33acfad9a9b0d8abe702dc1a2c3b07c4fd28e889acc8c952383022" => :mavericks
  end

  head do
    url "https://github.com/motemen/ghq.git"

    go_resource "github.com/codegangsta/cli" do
      url "https://github.com/codegangsta/cli.git",
          :revision => "1efa31f08b9333f1bd4882d61f9d668a70cd902e"
    end
  end

  option "without-completions", "Disable zsh completions"

  depends_on "go" => :build

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "981ab348d865cf048eb7d17e78ac7192632d8415"
  end

  go_resource "github.com/motemen/go-colorine" do
    url "https://github.com/motemen/go-colorine.git",
        :revision => "49ff36b8fa42db28092361cd20dcefd0b03b1472"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
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
