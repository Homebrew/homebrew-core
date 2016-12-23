class AmrClient < Formula
  desc "Ask Mr. Robot Simulator Client"
  homepage "http://www.askmrrobot.com/"
  url "https://static2.askmrrobot.com/amrbeta/client/AskMrRobotClient-159-osx.10.11-x64.zip"
  version "159"
  sha256 "53346959796c7f25038d17eccd5f21a56bbadd9d80f0c90387bcce01db8addd5"

  def install
    chmod 0755, "updater/amrupdate"
    chmod 0755, "client/amr"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"updater/amrupdate"
    bin.install_symlink libexec/"client/amr"
  end

  test do
    system "if [[ -x `which amr` ]]; then true; else false; fi"
    system "if [[ -x `which amrupdate` ]]; then true; else false; fi"
  end
end
