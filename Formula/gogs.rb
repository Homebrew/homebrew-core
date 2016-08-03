class Gogs < Formula
  desc "Go Git Service: A painless self-hosted Git service"
  homepage "https://gogs.io"
  url "https://cdn.gogs.io/gogs_v0.9.48_darwin_amd64.zip"
  version "0.9.48"
  sha256 "8afbd71fde279e77ed5b16c8a80ef409661ccb3953bf6cc867fbede532686475"

  def startup_script; <<-EOS.undent
    #!/bin/sh
    cd #{var/"gogs"} && ./gogs "$@"
    EOS
  end

  def migrate_script; <<-EOS.undent
    #!/bin/sh
    cd #{var}
    [ -d gogs.bak ] && { echo "#{var}/gogs.bak already exists, quitting" >&2; exit 1; }
    mv gogs gogs.bak
    brew reinstall gogs
    for d in custom data log; do [ -d gogs.bak/$d ] && cp -R gogs.bak/$d gogs; done
    EOS
  end

  def install
    (var/"gogs").mkpath
    (var/"gogs").install Dir["*"]
    (bin/"gogs-migrate").write migrate_script
    (bin/"gogs").write startup_script
  end

  def caveats; <<-EOS.undent
    If the `gogs web` command is failing after a `brew upgrade`, run:
        #{bin}/gogs-migrate
    See https://gogs.io/docs/upgrade/upgrade_from_binary for more info.
    EOS
  end

  test do
    system "gogs", "--version"
  end
end
