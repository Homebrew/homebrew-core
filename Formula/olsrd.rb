class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "http://www.olsr.org"
  # olsr's website is "ill" and does not contain the latest release.
  # https://github.com/OLSR/olsrd/issues/48
  url "https://github.com/OLSR/olsrd/archive/v0.9.8.tar.gz"
  sha256 "ee9e524224e5d5304dcf61f1dc5485c569da09d382934ff85b233be3e24821a3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d962f1a213860c614fafd91b494c4c06700c2d960645ff18bc410a071ba90250"
    sha256 cellar: :any_skip_relocation, big_sur:       "52333a59755987095e315f745c70d2187513099c2aff7692d8bf4711a44354d9"
    sha256 cellar: :any_skip_relocation, catalina:      "95e531e19da3a6e11bf48851691e411d3fb27acf7dc18ccf5bed5c32aa3df4ff"
    sha256 cellar: :any_skip_relocation, mojave:        "5ba1b0c584a2efe1d518be4032432818fca8bbccd3078e23ef7bbb3a9359a73e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "70402085753c70fb12f3e0f249bf109ac77e0a22d7be890ac6484d7ffce8501f"
  end

  depends_on "coreutils" => :build # needs GNU cp

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"
    lib.mkpath
    args = %W[
      DESTDIR=#{prefix}
      USRDIR=#{prefix}
      LIBDIR=#{lib}
      ETCDIR=#{etc}
    ]
    system "make", "build_all", *args
    system "make", "install_all", *args
  end

  plist_options startup: true, manual: "olsrd -f #{HOMEBREW_PREFIX}/etc/olsrd.conf"

  def startup_plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{HOMEBREW_PREFIX}/sbin/olsrd</string>
            <string>-f</string>
            <string>#{etc}/olsrd.conf</string>
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
    assert_match version.to_s, pipe_output("#{sbin}/olsrd")
  end
end
