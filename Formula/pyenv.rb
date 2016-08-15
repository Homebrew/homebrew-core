class Pyenv < Formula
  class Version < ::Version
    # versions with datetime (e.g. v0.4.0-20140110.1, v20140614) is obsolete.
    # those versions should be considered as older than ordinally versions (e.g. 1.0.0)
    DATETIME_VERSIONS = /\A(?:0\.[1-4]\.\d+-)?201[3-6]\d{4}(?:\.\d+)?\z/
    def <=>(other)
      if DATETIME_VERSIONS =~ self
        if DATETIME_VERSIONS =~ other
          super
        else
          -1
        end
      else
        if DATETIME_VERSIONS =~ other
          1
        else
          super
        end
      end
    end
  end

  PYENV_VERSION = "20160726"
  desc "Python version management"
  homepage "https://github.com/yyuu/pyenv"
  url "https://github.com/yyuu/pyenv/archive/v#{PYENV_VERSION}.tar.gz"
  sha256 "297040445f25912bea030be91b7d46c65eedbdf60655c2aae6226e88ed9b1346"
  head "https://github.com/yyuu/pyenv.git"
  version Pyenv::Version.new(PYENV_VERSION)

  bottle :unneeded

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended
  depends_on "readline" => [:recommended, :run]

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.pyenv add to your profile:
      export PYENV_ROOT=#{var}/pyenv

    To enable shims and autocompletion add to your profile:
      if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
