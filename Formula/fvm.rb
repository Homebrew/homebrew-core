class Fvm < Formula
  desc "Flutter SDK versions Manager"
  homepage "https://github.com/xinfeng-tech/fvm"
  url "https://github.com/xinfeng-tech/fvm/archive/v1.0.3.tar.gz"
  sha256 "5c2692e3af4e3420175b87b0a76e0943ba51df5af9db045fdaa498a2a43186b4"
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
      \. "#{opt_prefix}/init.sh"  # This loads fvm

    You can set $FVM_DIR to any location.

    Type `fvm help` for further information.
  EOS
  end

  test do
    output = pipe_output("#{prefix}/init.sh 2>&1")
    assert_no_match /No such file or directory/, output
  end
end
