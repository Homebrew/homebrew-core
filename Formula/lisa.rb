class Lisa < Formula
  desc "Lisa is a development tool for the Go Programming Language. It automatically runs your command and hot compile your code when it detects file system changes."
  homepage "http://miclle.me/lisa/"
  url "https://github.com/miclle/lisa/files/255510/v0.1.0.tar.gz"
  sha256 "a296aa36c915988796a421841785d4ea1d2cd45379655fcbac29f80c01b24a4c"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    libexec.install "lisa"

    chmod 0755, "#{libexec}/lisa"

    bin.install_symlink libexec/"lisa"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test lisa`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    # system "false"
    system bin/"lisa","--help"
  end
end