class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.3.3.tar.gz"
  sha256 "7023b1dc17626c5115b061e7ce02e06f006e35af92abf473334dffe7ff3c2d6d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.monitoring-plugins.org/download.html"
    regex(/href=.*?monitoring-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3b6bcee8dbfda43a02b4078bee48d314a7b990f792cdeb226f0727b9635fae1d"
    sha256 cellar: :any, arm64_ventura:  "6a930ca2aaedd2cf73365bc71fdc93273ba78cb893c117149500f9fe20f79f43"
    sha256 cellar: :any, arm64_monterey: "0b0be4236072aa4ffb4a7bcd0ff09f79546790c57b5dc9c9232173cb676e1e93"
    sha256 cellar: :any, arm64_big_sur:  "0baf0ab2e51519be149ee07a87927874729f38e4751be819d831466e144a8379"
    sha256 cellar: :any, sonoma:         "6e36fb81f542d103156865851c92a0d5a06c41d1e1815120de8568d8cab7f7df"
    sha256 cellar: :any, ventura:        "91b1eb7fd56d87474127afad01204c18a206bfe7cdd0e090ba0000f47de1a428"
    sha256 cellar: :any, monterey:       "f7c115e18c7e2d811caab8fa412fb45c55144aec6779f75576c837e7cfd47b98"
    sha256 cellar: :any, big_sur:        "470589d619ac73271cc89fc071640bf6d4448a34234f39bb0805a857623a15bf"
    sha256               x86_64_linux:   "a1a591f41c0bea670ae1592f05572b6e08c030e2e0cabfba9151dd5ba757f299"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
