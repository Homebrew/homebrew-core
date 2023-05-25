class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet."
  homepage "https://github.com/autobrr/autobrr"
  version "1.36.0"
  license "GPL-2.0-or-later"

  if Hardware::CPU.arch == :arm64
    url "https://github.com/autobrr/autobrr/releases/download/v#{version}/autobrr_#{version}_darwin_arm64.tar.gz"
    sha256 "cee7a60fada5da6308843d594cea3e7d03da17cd1a80e4fed22965039dd9298f"
  else
    url "https://github.com/autobrr/autobrr/releases/download/v#{version}/autobrr_#{version}_darwin_x86_64.tar.gz"
    sha256 "3b9ad4765af73b9267a4c062d73056ac7661aa285dc3e341f9c1272c4446530d"
  end

  def install
    bin.install "autobrr"
    bin.install "autobrrctl"
  end

  def post_install
    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr"]
    keep_alive true
  end

  def caveats
    <<~EOS
      autobrr will generate a default configuration file at first run located at:
        #{var}/autobrr/config.toml

      Please modify this file as necessary after running autobrr for the first time.
    EOS
  end

  test do
    system "#{bin}/autobrrctl", "version"
  end
end
