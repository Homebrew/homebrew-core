class ProducthuntCli < Formula
  desc "CLI application for the Product Hunt"
  homepage "https://sibis.dev/"
  version "0.1.0"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/sibis/producthunt-cli/releases/download/v0.1.0/producthunt-cli_0.1.0_Darwin_x86_64.tar.gz"
    sha256 "45941528552dca7175e2c4d68812fb8648d6eddad374c02f43e09003419d3367"
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/sibis/producthunt-cli/releases/download/v0.1.0/producthunt-cli_0.1.0_Linux_x86_64.tar.gz"
      sha256 "a03da77eb8b2b7e97243a4b7ce383fb6647b2b59a5b0df17e28204102102a199"
    end
  end

  depends_on "git"
  depends_on "zsh" => :optional

  conflicts_with "svn"
  conflicts_with "bash"

  def install
    bin.install "program"
    ...
  end

  plist_options :startup => false

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
...

  EOS
  end

  test do
    system "#{bin}/program --version"
    ...
  end
end
