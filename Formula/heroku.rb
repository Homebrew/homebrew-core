class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://toolbelt.heroku.com/standalone"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.43.12.tgz"
  sha256 "a4a70d9834eaa4ab4094ce5c47fb1148f7cc9603008ebe5b462c4f28a846fffc"
  head "https://github.com/heroku/heroku.git"

  bottle :unneeded

  depends_on :arch => :x86_64
  depends_on :ruby => "1.9"

  def install
    libexec.install Dir["*"]
    # turn off autoupdates (off by default in HEAD)
    if build.stable?
      inreplace libexec/"bin/heroku",
                "Heroku::Updater.inject_libpath",
                "Heroku::Updater.disable(\"Use `brew upgrade heroku` to update\")"
    end
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system bin/"heroku", "version"
  end
end
