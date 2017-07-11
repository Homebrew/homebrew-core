class Offlineimap < Formula
  desc "Synchronizes emails between two repositories"
  homepage "http://offlineimap.org/"
  url "https://github.com/OfflineIMAP/offlineimap/archive/v7.1.2.tar.gz"
  sha256 "7203435e34f73e90d1833b72c49a859decf7b5828384a2648ee4b2d1ef3bdc66"
  revision 1
  head "https://github.com/OfflineIMAP/offlineimap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "383a8102a3cd84f85424f4fd280ff4ff3fad8c3032802a6013a08846e8800d91" => :sierra
    sha256 "c89e281547c1cf23754a80e0fddd48f2aecc7e94de8b606daac6d400bedca3b4" => :el_capitan
    sha256 "c89e281547c1cf23754a80e0fddd48f2aecc7e94de8b606daac6d400bedca3b4" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "sphinx-doc" => :build

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "docs"
    man1.install "docs/offlineimap.1"
    man7.install "docs/offlineimapui.7"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("six").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end
    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
    libexec.install "bin/offlineimap" => "offlineimap.py"
    libexec.install "offlineimap"
    (bin/"offlineimap").write_env_script(libexec/"offlineimap.py",
      :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    To get started, copy one of these configurations to ~/.offlineimaprc:
    * minimal configuration:
        cp -n #{etc}/offlineimap.conf.minimal ~/.offlineimaprc

    * advanced configuration:
        cp -n #{etc}/offlineimap.conf ~/.offlineimaprc
    EOS
  end

  plist_options :manual => "offlineimap"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/offlineimap</string>
          <string>-u</string>
          <string>basic</string>
        </array>
        <key>StartInterval</key>
        <integer>300</integer>
        <key>RunAtLoad</key>
        <true />
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"offlineimap", "--version"
  end
end
