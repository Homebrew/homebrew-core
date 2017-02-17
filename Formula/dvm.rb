class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/getcarina/dvm"
  url "https://github.com/getcarina/dvm/archive/0.7.0.tar.gz"
  sha256 "ba49aa8e34bbbd8b96d27aa79f1e84daee72f625a412b1b65f35d2804285a279"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "29c0477105dffacb2826895fc543d396efbc1563512939f38658b774753f7b80" => :sierra
    sha256 "fe17b992aa8506e903642162d03addd1b106debff425e75a447f4293ccfdefbc" => :el_capitan
    sha256 "8c504a35ceb86496fc9d582e9642d4746b525e97c24008fb47957371e642ddfb" => :yosemite
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
      bash_completion.install "bash_completion" => "dvm"
      (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
      prefix.install_metafiles
    end
  end

  def caveats; <<-EOS.undent
    dvm is a shell function, and must be sourced before it can be used.
    Add the following command to your bash profile:
        [ -f #{opt_prefix}/dvm.sh ] && . #{opt_prefix}/dvm.sh
    EOS
  end

  test do
    output = shell_output("bash -c 'source #{prefix}/dvm.sh && dvm --version'")
    assert_match "Docker Version Manager version #{version}", output
  end
end
