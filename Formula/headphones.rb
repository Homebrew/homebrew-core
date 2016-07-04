class Headphones < Formula
  desc "Automatic music downloader for SABnzbd"
  homepage "https://github.com/rembo10/headphones"
  url "https://github.com/rembo10/headphones/archive/v0.5.16.tar.gz"
  sha256 "4dc789a48140ec2cfd62905c001397ef73b971dd79cd3cf24cf8b4dd1fe70143"
  head "https://github.com/rembo10/headphones.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66580fb1be0cc42040dbc101b0a79e67aaf21bd9abd51609d56c44e32df6f44c" => :el_capitan
    sha256 "44e240a8fcc6ee7d65e7ab242cf4225a11e81668711473e65fb25adf5525e461" => :yosemite
    sha256 "a51c67470df2d7b42d1f26b9d861553bbe62c5bd20598bc3d29260b946da8f70" => :mavericks
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/9b/53/4492f2888408a2462fd7f364028b6c708f3ecaa52a028587d7dd729f40b4/Markdown-2.6.6.tar.gz"
    sha256 "9a292bb40d6d29abac8024887bcfc1159d7a32dc1d6f1f6e8d6d8e293666c504"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def startup_script; <<-EOS.undent
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

  def caveats; <<-EOS.undent
    Headphones defaults to port 8181.
  EOS
  end

  plist_options :manual => "headphones"

  def plist; <<-EOS.undent
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
