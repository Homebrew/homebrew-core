class Dokku < Formula
  desc "Command-line client for the Dokku PaaS"
  homepage "http://dokku.viewdocs.io"
  url "https://github.com/dokku/dokku/archive/v0.12.5.tar.gz"
  sha256 "f336cd983ce060e2aa54a6e7de0f89d3ef7f908939daa9e958a055c88412493a"

  def install
    bin.install "contrib/dokku_client.sh" => "dokku"
  end

  def caveats; <<~EOS
    Run `dokku` from a repository with a git remote named `dokku` pointed
    at your Dokku host in order to use the script as normal, e.g.:
      git remote add dokku dokku@<dokku-host>:<app-name>

    or configure the `DOKKU_HOST`, `DOKKU_PORT` and `DOKKU_GIT_REMOTE`
    environment variables, e.g.:
      export DOKKU_HOST=dokku.me
      export DOKKU_PORT=22
      export DOKKU_GIT_REMOTE=dokku
    EOS
  end

  test do
    system bin/"dokku"
  end
end
