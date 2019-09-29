class Fvm < Formula
  desc "Flutter SDK versions Manager"
  homepage "https://github.com/xinfeng-tech/fvm"
  url "https://github.com/xinfeng-tech/fvm/archive/v1.0.5.tar.gz"
  sha256 "b2dcb8085acd84e6fe1d8918ada48d13a72b241b35a940d2db2659456d52fb13"
  head "https://github.com/xinfeng-tech/fvm.git"

  bottle :unneeded

  def install
    prefix.install "fvm.sh", "init.sh"
  end

  def caveats; <<~EOS
    You should create FVM's working directory if it doesn't exist:

      mkdir ~/.fvm

    Add the following to #{shell_profile} or your desired shell
    configuration file:

      export FVM_DIR="$HOME/.fvm"
      source "#{opt_prefix}/init.sh"  # This loads fvm

    You can set $FVM_DIR to any location.

    Type `fvm help` for further information.
  EOS
  end

  test do
    output = pipe_output("#{prefix}/init.sh 2>&1")
    assert_no_match /No such file or directory/, output
  end
end
