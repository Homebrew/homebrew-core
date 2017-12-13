class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.2.1.tar.gz"
  sha256 "bd7f105542e9903e776aa006c6931c1f5d3d477cb59af33a9162422efa477097"
  head "http://www.freediameter.net/hg/freeDiameter", :using => :hg

  bottle do
    sha256 "2217625f090f66370018131ceefb9ccdfd9f8fd64b73bf08a63a9d9a0166da8a" => :high_sierra
    sha256 "20927075755cc1df49f15c87defd3aa10154c94e4a249e895cb7f65be8e6db78" => :sierra
    sha256 "aa6f29018beafbe23e475334ed5be3718ba428e88b0741ef199d66cdaa988d08" => :el_capitan
    sha256 "786f9873dbf0e85e8a54272697404d99fa60f6872fc8fdad54d66e8184c4dc28" => :yosemite
    sha256 "c031628f3bbd387bdea44364fc6e99065216b68f2d2bf61abf516055e69f6620" => :mavericks
  end

  option "with-all-extensions", "Enable all extensions"

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"

  if build.with? "all-extensions"
    depends_on "swig" => :build
    depends_on :postgresql
    depends_on :mysql
  end

  def install
    args = std_cmake_args + %W[
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]
    args << "-DALL_EXTENSIONS=ON" if build.with? "all-extensions"

    mkdir "build" do
      system "cmake", "..", *args
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
