class Leafnode < Formula
  desc "NNTP server for small sites"
  homepage "http://www.leafnode.org/"
  url "https://downloads.sourceforge.net/project/leafnode/leafnode/1.11.11/leafnode-1.11.11.tar.bz2"
  sha256 "3ec325216fb5ddcbca13746e3f4aab4b49be11616a321b25978ffd971747adc0"

  bottle :disable, "leafnode hardcodes the user at compile time with no override available."

  depends_on "pcre"

  def install
    (var/"spool/news/leafnode").mkpath
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--with-user=#{ENV["USER"]}", "--with-group=admin",
                          "--sysconfdir=#{etc}/leafnode", "--with-spooldir=#{var}/spool/news/leafnode"
    system "make", "install"
  end

  def caveats; <<~EOS
    For starting fetchnews and texpire, create links,
      ln -s #{opt_prefix}/homebrew.mxcl.{fetchnews,texpire}.plist ~/Library/LaunchAgents
    And to start the services,
      launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.{fetchnews,texpire}.plist
  EOS
  end

  plist_options :manual => "leafnode"

  plist do
    {
      :OnDemand           => true,
      :Program            => "#{opt_sbin}/leafnode",
      :Sockets            => { :Listeners => { :SockServiceName => "nntp" } },
      :WorkingDirectory   => "#{var}/spool/news",
      :inetdCompatibility => { :Wait => false },
    }
  end

  plist do
    {
      :KeepAlive        => false,
      :Label            => "homebrew.mxcl.fetchnews",
      :Program          => "#{opt_sbin}/fetchnews",
      :StartInterval    => 1800,
      :WorkingDirectory => "#{var}/spool/news",
    }
  end

  plist do
    {
      :KeepAlive        => false,
      :Label            => "homebrew.mxcl.texpire",
      :Program          => "#{opt_sbin}/texpire",
      :StartInterval    => 25000,
      :WorkingDirectory => "#{var}/spool/news",
    }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leafnode-version")
  end
end
