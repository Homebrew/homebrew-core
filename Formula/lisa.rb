class Lisa < Formula
  desc "Starting a file system watcher then execute a command."
  homepage "http://miclle.me/lisa/"
  url "https://github.com/miclle/lisa/files/255510/v0.1.0.tar.gz"
  sha256 "a296aa36c915988796a421841785d4ea1d2cd45379655fcbac29f80c01b24a4c"

  def install
    libexec.install "lisa"

    chmod 0755, "#{libexec}/lisa"

    bin.install_symlink libexec/"lisa"
  end

  test do
    system bin/"lisa", "--help"
  end
end
