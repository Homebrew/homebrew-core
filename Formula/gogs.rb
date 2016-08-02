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

  def install
    (var/"gogs").mkpath
    (var/"gogs").install Dir["*"]
    (bin/"gogs").write startup_script
  end

  test do
    system "gogs", "--version"
  end
end
