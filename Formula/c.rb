class C < Formula
  desc "Git utility script to switch between recent branches"
  homepage "https://github.com/AndrewRayCode/c"
  url "https://github.com/AndrewRayCode/c-releases/raw/master/c-0.0.2.tar.gz"
  sha256 "a20071425f7b91d3f37c9f2a9af3a0c643588dce4f2466a4ea197e42b707ccfb"

  def install
    bin.install %w[c c_recent_branches_completer]
  end

  def caveats; <<-EOS.undent
    ⚠️  To get command line completion for c, add the following to your .bashrc

    # Set up tab completion for git completion 'c' utility script
    if [[ -d "$(brew --prefix c)" ]]; then
        source "$(brew --prefix c)/c_recent_branches_completer"
    fi
    EOS
  end
end

