class Chruby < Formula
  desc "Ruby environment tool"
  homepage "https://github.com/postmodern/chruby#readme"
  url "https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz"
  sha256 "7220a96e355b8a613929881c091ca85ec809153988d7d691299e0a16806b42fd"

  head "https://github.com/postmodern/chruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff70dff83817f093d39384a40d3dfb2aaccc1cbe475d58383d4ef157085f2c64" => :el_capitan
    sha256 "eb14810c552b693c5ae82a577be81398e7dfeadc5489666bb0ff89581f09bfe4" => :yosemite
    sha256 "c7ede5a22e512d3c22406f222b539fe05b78dfb9721cfff8ce94ed0357883ba5" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add the following to the ~/.bashrc or ~/.zshrc file:

      source #{opt_share}/chruby/chruby.sh

    By default chruby will search for Rubies installed into /opt/rubies/ or
    ~/.rubies/. For non-standard installation locations, simply set the RUBIES
    variable after loading chruby.sh:

      RUBIES+=(
        /opt/jruby-1.7.0
        $HOME/src/rubinius
      )

    If you are migrating from another Ruby manager, set `RUBIES` accordingly:

      RVM:   RUBIES+=(~/.rvm/rubies/*)
      rbenv: RUBIES+=(~/.rbenv/versions/*)
      rbfu:  RUBIES+=(~/.rbfu/rubies/*)

    To enable auto-switching of Rubies specified by .ruby-version files,
    add the following to ~/.bashrc or ~/.zshrc:

      source #{opt_share}/chruby/auto.sh
    EOS
  end
end
