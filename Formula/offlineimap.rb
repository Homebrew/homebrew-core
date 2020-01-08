class Offlineimap < Formula
  desc "Synchronizes emails between two repositories"
  homepage "https://www.offlineimap.org/"
  url "https://github.com/OfflineIMAP/offlineimap/archive/v7.3.0.tar.gz"
  sha256 "d8378e82e392c70f5c20cb08705687da30cd427f2bca539939311512777e6659"
  head "https://github.com/OfflineIMAP/offlineimap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "deaa78edce86b63e6d24b563877f6c246c2d1cf2987da172174fbd2207112eb1" => :catalina
    sha256 "deaa78edce86b63e6d24b563877f6c246c2d1cf2987da172174fbd2207112eb1" => :mojave
    sha256 "deaa78edce86b63e6d24b563877f6c246c2d1cf2987da172174fbd2207112eb1" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "sphinx-doc" => :build
  depends_on "python@2" # does not support Python 3

  resource "rfc6555" do
    url "https://files.pythonhosted.org/packages/58/a8/1dfba2db1f744657065562386069e547eefea9432d3f520d4af5b5fabd28/rfc6555-0.0.0.tar.gz"
    sha256 "191cbba0315b53654155321e56a93466f42cd0a474b4f341df4d03264dcb5217"
  end

  resource "selectors2" do
    url "https://files.pythonhosted.org/packages/a4/54/d690d931777ca7310562997fab09019582e6e557984c02d7647f3654f7f5/selectors2-2.0.1.tar.gz"
    sha256 "81b77c4c6f607248b1d6bbdb5935403fef294b224b842a830bbfabb400c81884"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  def install
    xy = Language::Python.major_minor_version "python2"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "docs"
    man1.install "docs/offlineimap.1"
    man7.install "docs/offlineimapui.7"

    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
    libexec.install "bin/offlineimap" => "offlineimap.py"
    libexec.install "offlineimap"
    (bin/"offlineimap").write_env_script(libexec/"offlineimap.py",
      :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<~EOS
    To get started, copy one of these configurations to ~/.offlineimaprc:
    * minimal configuration:
        cp -n #{etc}/offlineimap.conf.minimal ~/.offlineimaprc

    * advanced configuration:
        cp -n #{etc}/offlineimap.conf ~/.offlineimaprc
  EOS
  end

  plist_options :manual => "offlineimap"

  def plist; <<~EOS
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
          <string>-q</string>
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
