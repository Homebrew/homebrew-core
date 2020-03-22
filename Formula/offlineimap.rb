class Offlineimap < Formula
  desc "Synchronizes emails between two repositories"
  homepage "https://www.offlineimap.org/"
  url "https://github.com/OfflineIMAP/offlineimap/archive/v7.3.2.tar.gz"
  sha256 "d47b564858c3e9fc7726ef58c9a4ee518d2958c5de3dcad6cd78b7cfe0a6bdef"
  head "https://github.com/OfflineIMAP/offlineimap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9f7c26d77e5b5f117847fb068a5bdd9c4d691c73fa8c94aae12bec425953816" => :catalina
    sha256 "843997b39d0b652700a5c6ccb2ce1a7efe76c32577018d792e25690c4166bb12" => :mojave
    sha256 "843997b39d0b652700a5c6ccb2ce1a7efe76c32577018d792e25690c4166bb12" => :high_sierra
  end

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  # Will never support Python 3
  # https://github.com/OfflineIMAP/offlineimap/issues/616#issuecomment-491003691
  uses_from_macos "python@2"

  resource "rfc6555" do
    url "https://files.pythonhosted.org/packages/58/a8/1dfba2db1f744657065562386069e547eefea9432d3f520d4af5b5fabd28/rfc6555-0.0.0.tar.gz"
    sha256 "191cbba0315b53654155321e56a93466f42cd0a474b4f341df4d03264dcb5217"
  end

  resource "selectors2" do
    url "https://files.pythonhosted.org/packages/a4/54/d690d931777ca7310562997fab09019582e6e557984c02d7647f3654f7f5/selectors2-2.0.1.tar.gz"
    sha256 "81b77c4c6f607248b1d6bbdb5935403fef294b224b842a830bbfabb400c81884"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  def install
    ENV.delete("PYTHONPATH")
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Remove hardcoded python2 that does not exist on high-sierra or mojave
    inreplace "Makefile", "python2", "python"
    inreplace "bin/offlineimap", "python2", "python"

    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
    libexec.install "bin/offlineimap" => "offlineimap.py"
    libexec.install "offlineimap"
    (bin/"offlineimap").write_env_script(libexec/"offlineimap.py",
      :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats
    <<~EOS
      To get started, copy one of these configurations to ~/.offlineimaprc:
      * minimal configuration:
          cp -n #{etc}/offlineimap.conf.minimal ~/.offlineimaprc

      * advanced configuration:
          cp -n #{etc}/offlineimap.conf ~/.offlineimaprc
    EOS
  end

  plist_options :manual => "offlineimap"

  def plist
    <<~EOS
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
