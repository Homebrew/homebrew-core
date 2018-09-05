class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://www.jenv.be/"
  url "https://github.com/gcuisinier/jenv/archive/0.4.4.tar.gz"
  sha256 "74b48d9c33ceae4e141272c4096086c6ec1a8f10073da379b816518615c79881"
  head "https://github.com/gcuisinier/jenv.git"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
