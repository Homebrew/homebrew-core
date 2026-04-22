class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.5/nagios-plugins-2.5.tar.gz"
  sha256 "44d1510b5e17055fd9aa4a1d9662a234fc5d5c1b96548852c8e78701584b2684"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "5628345a480acea682615f3e8d7019113801d34734421111ee9eec7feef0c2ee"
    sha256 arm64_sequoia: "04adde77b1eaf68bba563e941c8d91cbed9f3e76c8e97bab5ecafd6c5f74cce4"
    sha256 arm64_sonoma:  "87dc4aa01fe10b6d83ca62542866a94f1bdcbeb7450434e40ffcec4672e9b25b"
    sha256 sonoma:        "d242844eee49592bfe4f1db06b6ad4df79b1d398b873338759035b1d199b6958"
    sha256 arm64_linux:   "f32f85405c13021c66d8877004538df510746e256c491a8f0662ec2889198f5e"
    sha256 x86_64_linux:  "f192dfe18ab4a936a948df908c4cdc26eeea100ad2ad6eaa75115b866f6d3a21"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "bind"
  end

  conflicts_with "monitoring-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args(prefix: libexec)
    system "make", "install"
    sbin.write_exec_script libexec.glob("sbin/*")
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H brew.sh -s 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
