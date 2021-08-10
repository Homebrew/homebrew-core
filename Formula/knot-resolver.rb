class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.4.0.tar.xz"
  sha256 "534af671b98433b23b57039acc9d7d3c100a4888a8cf9aeba36161774ca0815e"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 2
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d5ab757a24c78ef72e9e8e27888ed7b3e72973ca2b21cac2cfb8361882f332d6"
    sha256 big_sur:       "3524936cbe69b7950b4509d296e4b93666f3755ff6af7c8b6f91209cf3753533"
    sha256 catalina:      "a42f4cbacb1b36b47334394496957417d26dc61731fca130c0cb6eecdeb40742"
    sha256 mojave:        "0a335e7cde3394155ac5a172dd881974cd0ea53c02e7c92766af315e1463d176"
    sha256 x86_64_linux:  "fd8eee3900fbe46a70bf0db719b697709479406d275837dd4e7b420ef145188c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit-openresty"

  on_linux do
    depends_on "libcap-ng"
    depends_on "systemd"
  end

  def install
    args = std_meson_args + ["--default-library=static"]
    on_linux do
      args << "-Dsystemd_files=enabled"
    end

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    (var/"knot-resolver").mkpath
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{var}/knot-resolver</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/kresd</string>
          <string>-c</string>
          <string>#{etc}/knot-resolver/kresd.conf</string>
          <string>-n</string>
        </array>
        <key>StandardInPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/knot-resolver.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
