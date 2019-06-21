class Docksal < Formula
  desc "Docker powered web development environments for macOS, Windows & Linux"
  homepage "https://docksal.io"
  url "https://github.com/docksal/docksal/archive/v1.12.3.tar.gz"
  sha256 "252a8ce0194fbcacb0a2b7dd6d578843f4ada2cd31c1859350a53791827932a0"

  def install
    mkdir_p "~/.docksal"
    touch "~/.docksal/docksal.env"
    system "echo", "'DOCKER_NATIVE=1'", ">>", "~/.docksal/docksal.env"
    bin.install "bin/fin"
  end

  def caveats
    s = "VirtualBox can be installed via `brew cask install virtualbox`\n"
    s += "Docker can be installed via `brew cask install docker`\n"
    s += "For Sandbox Server support run: `echo 'CI=1' >> ~/.docksal/docksal.env`\n"
    s += "For Katacoda mode support run: `echo 'KATACODA=1' >> ~/.docksal/docksal.env`\n"
    s
  end

  test do
    system "#{bin}/fin", "--version"
  end
end
