class GqCli < Formula
  desc "A command-line tool for goquant.io"
  homepage "https://goquant.io"
  url "https://brickelldatabros1aboah.blob.core.windows.net/public/macos-x86.tar.gz"
  license "MIT"
  version "0.0.1"

  if Hardware::CPU.arm?
    url "https://brickelldatabros1aboah.blob.core.windows.net/public/macos-arm.tar.gz"
    sha256 "d70775df10c53b5e6b38af46c2a963bd094417c0e621db82d5adb398b634913a"
  else
    url "https://brickelldatabros1aboah.blob.core.windows.net/public/macos-x86.tar.gz"
    sha256 "99a64a8b7164c66a03aa8f34e68a7acb4cf2254642345839c742afd989a5f2f1"
  end
  def install
    bin.install "gq"
  end

  def post_install
    if system("#{prefix}/install.sh")
      ohai "Installation successful"
    else
      opoo "Installation failed"
    end
  end

  test do
    assert_match "gq", shell_output("#{bin}/gq --help")
  end
end
