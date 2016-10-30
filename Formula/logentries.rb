class Logentries < Formula
  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.4.40.tar.gz"
  sha256 "65c14106596ac40870f5a7829e9bb61e9ac6e389a03ca3dcbeb5a944e342f7fd"
  head "https://github.com/logentries/le.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "497fb9fde20d96acb77019d983c0c2a8d0b53956c41102bda41d3c9d3104ae10" => :sierra
    sha256 "a7e9da0109b525f9d3ab9143c4ded9edad0a023da1517262e08920a1ab0fd817" => :el_capitan
    sha256 "477138f1ee0fa5a123b12886edf0e8a81e7bcfb725949976855eaa50c1304e8d" => :yosemite
    sha256 "01edb0fe82fade9c94c86f93e0ab284d6eda959d007eb747908819e395df1bee" => :mavericks
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
