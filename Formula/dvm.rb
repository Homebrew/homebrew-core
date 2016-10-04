class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/getcarina/dvm"
  url "https://github.com/getcarina/dvm/archive/0.6.4.tar.gz"
  sha256 "7ff3bc5271432b7f5da535cd04228bf212dd2965ed15998837d660452094ff0e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bc6f4ae14d503cf3fcf0f45c4efd03fd010a6a31c4cb2590608e30361ade2764" => :sierra
    sha256 "3d0f0c4ab5c5b0f3505b3219446aad562b4ce5022fcdc1d150cfb5cc08fa51de" => :el_capitan
    sha256 "6c9b14532b9ba5685d4f21ba8ee81e63482065e7cedc825143a0080962ea75ea" => :yosemite
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
