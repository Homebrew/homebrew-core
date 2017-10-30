class Headphones < Formula
  desc "Automatic music downloader for SABnzbd"
  homepage "https://github.com/rembo10/headphones"
  url "https://github.com/rembo10/headphones/archive/v0.5.18.tar.gz"
  sha256 "5558669ee64448c82a90a4f2d8755ef9e7337b95b44354772fb2898769a04aeb"
  head "https://github.com/rembo10/headphones.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6038f613b50ab4d7c3f67a1a45547ba2349d96fc158fd99d4e1a46357e5d7992" => :high_sierra
    sha256 "913f1f0ea6600b6aa4bb6f4f9fcfd6c5447f072334b024faf40da2d7ed6b0600" => :sierra
    sha256 "fb9288d3885ac6ee18b6ee3292d7fe886f8b5d538b4876f3bdd32309e3643431" => :el_capitan
    sha256 "be688187ebdfd25f221b227a9aa6df3e8015788f564bdfdc524cd99834540d80" => :yosemite
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d4/32/642bd580c577af37b00a1eb59b0eaa996f2d11dfe394f3dd0c7a8a2de81a/Markdown-2.6.7.tar.gz"
    sha256 "daebf24846efa7ff269cfde8c41a48bb2303920c7b2c7c5e04fa82e6282d05c0"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def startup_script; <<~EOS
    #!/bin/bash
    export PYTHONPATH="#{libexec}/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/Headphones.py" --datadir="#{etc}/headphones" "$@"
    EOS
  end

  def install
    # TODO: strip down to the minimal install.
    libexec.install Dir["*"]

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    (bin/"headphones").write(startup_script)
  end

  def caveats; <<~EOS
    Headphones defaults to port 8181.
  EOS
  end

  plist_options :manual => "headphones"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/headphones</string>
        <string>-q</string>
        <string>-d</string>
        <string>--nolaunch</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match "Music add-on", shell_output("#{bin}/headphones -h")
  end
end
