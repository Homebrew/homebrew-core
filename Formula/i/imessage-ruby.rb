class ImessageRuby < Formula
  desc "Command-line tool to send text and attachment in Message.app"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "09031e60548f34f05e07faeb0e26b002aeb655488d152dd811021fba8d850162"
  license "MIT"
  head "https://github.com/linjunpop/imessage.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6c9c93e10c1079ddab1763ced2e4dd34ccbacabdfd6dc6445186927f1e51abf4"
  end

  depends_on :macos # uses Message.app
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "imessage.gemspec", "-o", "imessage-#{version}.gem"
    system "gem", "install", "--ignore-dependencies", "--no-document", "imessage-#{version}.gem"

    bin.install libexec/"bin/imessage"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "imessage v#{version}", shell_output("#{bin}/imessage --version")
  end
end
