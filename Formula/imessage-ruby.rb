class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "09031e60548f34f05e07faeb0e26b002aeb655488d152dd811021fba8d850162"
  license "MIT"
  head "https://github.com/linjunpop/imessage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c538ac24ec3ce437d868267582bd68aaa500eeb5a9bdbd3d0d80398b4bab19d"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "imessage.gemspec", "-o", "imessage-#{version}.gem"
    system "gem", "install", "--local", "--verbose", "imessage-#{version}.gem", "--no-document"

    bin.install libexec/"bin/imessage"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    if build.head?
      system "#{bin}/imessage", "--version"
    else
      assert_match "imessage v#{version}", shell_output("#{bin}/imessage --version")
    end
  end
end
