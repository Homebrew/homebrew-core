class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.3.2.tar.gz"
  sha256 "ce05b4bf2a04cd2f472e77ba4b86fbfca690bfc83e51da8ce0e575804b763eda"
  head "http://www.freediameter.net/hg/freeDiameter", :using => :hg

  bottle do
    cellar :any
    sha256 "8c60c4c5831c6d3a538a130a7aea101b6dc8d2f0351c6c1cd418b534cb97f366" => :catalina
    sha256 "aacb7d5749e234dd8937365b3b493b593a4fc1be5d70c9aed95596b8b238f46d" => :mojave
    sha256 "e194caf5035629cf10d8872e0c21ca86b8b4f4ae6665ce2d4a424ee2ea5794fb" => :high_sierra
    sha256 "0f1a491d96a02003555ee8101b6e8d25e580bc8416bb1cdb4f877950dd0a3986" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DDEFAULT_CONF_PATH=#{etc}",
                      "-DDISABLE_SCTP=ON"
      system "make"
      system "make", "install"
    end

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
  end

  def caveats; <<~EOS
    To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

    Sample configuration files can be found in #{doc}.

    For more information about freeDiameter configuration options, read:
      http://www.freediameter.net/trac/wiki/Configuration

    Other potentially useful files can be found in #{opt_pkgshare}/contrib.
  EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/freeDiameterd</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
