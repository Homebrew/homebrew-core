class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/getcarina/dvm"
  url "https://github.com/getcarina/dvm/archive/0.6.3.tar.gz"
  sha256 "09089036d881a6f3544198d93be82e5861cbc5f8682bfa3466e4d099923eb493"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1cc9876c3f0a77bde1f9db2821f91a80c22b8575816a6e903223ed0bcd08c3f" => :el_capitan
    sha256 "ae148f98c7a88130e344036f769b4b94c9e278ede6362c5dd17efb6ab4b33824" => :yosemite
    sha256 "ddb8a34197f47b6b53e5fe8d599d8678cea60a63e33edd96b86b0a9646fe51cf" => :mavericks
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
