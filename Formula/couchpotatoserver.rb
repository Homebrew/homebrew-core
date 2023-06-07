class Couchpotatoserver < Formula
  desc "Download movies automatically"
  homepage "https://couchpota.to"
  url "https://github.com/CouchPotato/CouchPotatoServer/archive/build/3.0.1.tar.gz"
  sha256 "f08f9c6ac02f66c6667f17ded1eea4c051a62bbcbadd2a8673394019878e92f7"
  license "GPL-3.0"
  head "https://github.com/CouchPotato/CouchPotatoServer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f8c2e92a584c48ec2a693d5e7e4cf48ef29fe40b3501668d0205357b4c901c8c"
  end

  disable! date: "2022-10-19", because: :repo_archived

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
