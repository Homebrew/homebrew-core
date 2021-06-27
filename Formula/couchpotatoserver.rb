class Couchpotatoserver < Formula
  desc "Download movies automatically"
  homepage "https://couchpota.to"
  url "https://github.com/CouchPotato/CouchPotatoServer/archive/build/3.0.1.tar.gz"
  sha256 "f08f9c6ac02f66c6667f17ded1eea4c051a62bbcbadd2a8673394019878e92f7"
  license "GPL-3.0"
  head "https://github.com/CouchPotato/CouchPotatoServer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d627b16a937b075e2a3615b1a33fb0e250674b8e541390a577fb14f6fc14b2b9"
    sha256                               big_sur:       "d4e28b8587a9e0dc167013da20cef7bad006f856e0b34e69a7e34c0065b08f2b"
    sha256                               catalina:      "d4e28b8587a9e0dc167013da20cef7bad006f856e0b34e69a7e34c0065b08f2b"
    sha256                               mojave:        "d4e28b8587a9e0dc167013da20cef7bad006f856e0b34e69a7e34c0065b08f2b"
  end

  def install
    prefix.install_metafiles
    inreplace_files = %w[
      couchpotato/core/helpers/variable.py
      init/freebsd
      init/synology
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
    rm_f "libs/unrar2/unrar" # bundled i386 executable, breaks relocatability
    libexec.install Dir["*"]
    (bin+"couchpotatoserver").write(startup_script)
  end

  service do
    run [opt_bin/"couchpotatoserver", "--quiet"]
  end

  def startup_script
    <<~EOS
      #!/bin/bash
      python "#{libexec}/CouchPotato.py"\
             "--pid_file=#{var}/run/couchpotatoserver.pid"\
             "--data_dir=#{etc}/couchpotatoserver"\
             "$@"
    EOS
  end

  test do
    system "#{bin}/couchpotatoserver", "--help"
  end
end
