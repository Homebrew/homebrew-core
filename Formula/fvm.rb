class Fvm < Formula
  desc "Flutter SDK versions Manager"
  homepage "https://github.com/dashixiong91/fvm"
  url "https://github.com/dashixiong91/fvm/archive/v1.1.5.tar.gz"
  sha256 "3ad05b34dcba7370753f60e5323ec80f3a3108d26498ded5be9fcd7cb15b5015"
  head "https://github.com/dashixiong91/fvm.git"

  bottle :unneeded

  def install
    libexec.install "package.json"
    libexec.install Dir["libexec/*"]
    prefix.install_symlink libexec/"init.sh"
    (bin/"fvm").write_env_script "#{libexec}/fvm.sh", :PREFIX => HOMEBREW_PREFIX
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
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
    output = pipe_output("#{libexec}/fvm.sh 2>&1")
    assert_no_match /No such file or directory/, output
  end
end
