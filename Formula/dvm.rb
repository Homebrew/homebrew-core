class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/getcarina/dvm"
  url "https://github.com/getcarina/dvm/archive/0.6.4.tar.gz"
  sha256 "7ff3bc5271432b7f5da535cd04228bf212dd2965ed15998837d660452094ff0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e046329279fd7c2c093a4159b60755161370721400e10da6df23a34a1efa97eb" => :sierra
    sha256 "a47592736f3dff452ac0060602bf915a763255102fe75adaf6e6dea4203f4ceb" => :el_capitan
    sha256 "beb50586491e083878940a059491b4ab40802e5fb417876532a7185340ab8d48" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.append_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/getcarina/dvm"
    dir.install buildpath.children

    cd dir do
      # `depends_on "glide"` already has this covered
      inreplace "Makefile", %r{^.*go get github.com/Masterminds/glide.*$\n}, ""

      system "make", "VERSION=#{version}", "UPGRADE_DISABLED=true"
      prefix.install "dvm.sh"
      prefix.install "bash_completion"
      (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
      prefix.install_metafiles
    end
  end

  def caveats; <<-EOS.undent
    dvm is a shell function, and must be sourced before it can be used.
    Add the following command to your bash profile:

        [[ -s "$(brew --prefix dvm)/dvm.sh" ]] && source "$(brew --prefix dvm)/dvm.sh"

    To enable tab completion of commands, add the following command to your bash profile:
        [[ -s "$(brew --prefix dvm)/bash_completion" ]] && source "$(brew --prefix dvm)/bash_completion"

    EOS
  end

  test do
    output = shell_output("bash -c 'source #{prefix}/dvm.sh && dvm --version'")
    assert_match "Docker Version Manager version #{version}", output
  end
end
