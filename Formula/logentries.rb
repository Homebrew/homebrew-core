class Logentries < Formula
  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.4.40.tar.gz"
  sha256 "65c14106596ac40870f5a7829e9bb61e9ac6e389a03ca3dcbeb5a944e342f7fd"
  head "https://github.com/logentries/le.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "357126917e60bc1173fdb291b91e30e6e55f8bd0a5feae3dbf295f9a2a9d265a" => :el_capitan
    sha256 "003b2b7ce5813bc36134b00f11fad40e9d45f7c9b8cf70231cd05af0d31f23ed" => :yosemite
    sha256 "200d2518170ed60e7b885dbefbc5bfcc319b90bf3c8729c28597182dcddced2a" => :mavericks
  end

  conflicts_with "le", :because => "both install a le binary"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "le monitor"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{opt_bin}/le</string>
        <string>monitor</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/le --help", 4)
  end
end
