class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/v3.01.tar.gz"
  sha256 "0e1e16f3706efa98893e33b1602cc00bb3d8e22e269bfc5a1a078559e4c21ce6"
  head "https://github.com/get-iplayer/get_iplayer.git", :branch => "develop"

  depends_on "atomicparsley" => :recommended
  depends_on "ffmpeg" => :recommended

  depends_on :macos => :yosemite

  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.39.tar.gz"
    sha256 "11950da7636cb786efd3bfb5891da4c820975276bce43175214391e5c32b7b96"
  end

  resource "Mojolicious" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-7.33.tar.gz"
    sha256 "3bf13d60663fc5fcfb7689ba71e0b7da2d5ac818d26b39da55f469ebb3f8fb02"
  end

  def install
    resource("IO::Socket::IP").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    resource("Mojolicious").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    inreplace ["get_iplayer", "get_iplayer.cgi"] do |s|
      s.gsub!(/^(my \$version_text);/i, "\\1 = \"#{pkg_version}-homebrew\";")
      s.gsub! "#!/usr/bin/env perl", "#!/usr/bin/perl"
    end

    man1.install "get_iplayer.1"

    libexec.install "get_iplayer"
    (bin/"get_iplayer").write_env_script \
      "#{libexec}/get_iplayer",
      :PERL5LIB => "#{libexec}/lib/perl5:$PERL5LIB"

    libexec.install "get_iplayer.cgi"
    (libexec/"get_iplayer.cgi").chmod 0444

    (libexec/"get_iplayer_web_pvr").write <<-EOS.undent
      #!/bin/bash
      source "#{etc}/default/get_iplayer_web_pvr"
      echo "Starting Web PVR Manager (Ctrl-C to stop)..."
      screen -d -m /usr/bin/perl "#{libexec}/get_iplayer.cgi" \
        -l $LISTEN -p $PORT -g "#{libexec}/get_iplayer"
      echo "Waiting for Web PVR Manager to start..."
      sleep 5
      echo "Opening Web PVR Manager..."
      open "http://$LISTEN:$PORT"
      echo "Showing Web PVR Manager output..."
      screen -r
    EOS
    (libexec/"get_iplayer_web_pvr").chmod 0555
    (bin/"get_iplayer_web_pvr").write_env_script \
      "#{libexec}/get_iplayer_web_pvr",
      :PERL5LIB => "#{libexec}/lib/perl5:$PERL5LIB"

    (buildpath/"get_iplayer_web_pvr_default").write <<-EOS.undent
      # use 0.0.0.0 to bind to all interfaces
      LISTEN=127.0.0.1
      # port must be higher than 1024 for unprivileged users
      PORT=1935
    EOS
    (etc/"default").install "get_iplayer_web_pvr_default" =>
                            "get_iplayer_web_pvr"
  end

  test do
    output = shell_output("\"#{bin}/get_iplayer\" --refresh --refresh-include=\"BBC None\" --quiet dontshowanymatches 2>&1")
    assert_match "get_iplayer #{pkg_version}-homebrew", output, "Unexpected version"
    assert_match "INFO: 0 Matching Programmes", output, "Unexpected output"
    assert_match "INFO: Using concurrent indexing", output,
                         "Mojolicious not found"
  end
end
