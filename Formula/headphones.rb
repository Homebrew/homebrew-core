class Headphones < Formula
  desc "Automatic music downloader for SABnzbd"
  homepage "https://github.com/rembo10/headphones"
  url "https://github.com/rembo10/headphones/archive/v0.5.19.tar.gz"
  sha256 "604365d356c2079bd55955aa8448a70c39cc5f32a71049a49876847423ce5d12"
  head "https://github.com/rembo10/headphones.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "763b172d0d826db56c48f140570dea31e7b0a557116b9adfc50b5f63b387dec1" => :catalina
    sha256 "e10c9c8639a61bede2b7b765ce56fc72d90949fd822f3bcf870eec78ff51bc59" => :mojave
    sha256 "c22670540bfa23e92a25a0efa6af4fe9f29967a45d4b8c5d8de0b28c060ac9d5" => :high_sierra
    sha256 "d64f16c7ce5484cd9e69902d1b4ea8299e9b093b8837c624ed0ef623aeb748fb" => :sierra
    sha256 "a17c424aac1d91fb570d3e63db548c37b4c64f92ed988bb935cb4fa02c12fc5a" => :el_capitan
  end

  depends_on "python@2" # does not support Python 3

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"
    sha256 "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"
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
