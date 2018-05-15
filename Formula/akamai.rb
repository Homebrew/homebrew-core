class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.0.2.tar.gz"
  sha256 "d3855ddbaf11cac3f0f164937faa1153ea9d1ab41175989311eab674d9b4a635"

  bottle do
    cellar :any_skip_relocation
    sha256 "a79032313a80d5d55b35bd6ec057f1b990f613da3dbfc278e631168365776176" => :high_sierra
    sha256 "31ea9f63acbca72f594346256122d4898b2ce65b1ca53a0785b00bef62700628" => :sierra
    sha256 "a383a729459136fab43a0ce6e1f822fecb22bcb351e7fec32eee9ac6810c7363" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "dep", "ensure"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end

    output = <<~EOS
      _akamai_cli_bash_autocomplete() {
          local cur opts base
          COMPREPLY=()
          cur="${COMP_WORDS[COMP_CWORD]}"
          opts=$( ${COMP_WORDS[@]:0:$COMP_CWORD} --generate-auto-complete )
          COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
          return 0
      }
      complete -F _akamai_cli_bash_autocomplete akamai
    EOS
    (bash_completion/"akamai").write output

    (zsh_completion/"_akamai").write <<~EOS
      set -k
      autoload -U compinit && compinit
      autoload -U bashcompinit && bashcompinit
    EOS
    (zsh_completion/"_akamai").append_lines output
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
