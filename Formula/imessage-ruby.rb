class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "09031e60548f34f05e07faeb0e26b002aeb655488d152dd811021fba8d850162"
  license "MIT"
  head "https://github.com/linjunpop/imessage.git", branch: "master"

  depends_on "ruby" if Hardware::CPU.arm?

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "imessage.gemspec", "-o", "imessage-#{version}.gem"
    system "gem", "install", "--local", "--verbose", "imessage-#{version}.gem", "--no-document"
    system "gem", "info", "imessage"

    (bin/"imessage").write_env_script libexec/"bin/imessage",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s
  end

  test do
    if build.head?
      system "#{bin}/imessage", "--version"
    else
      assert_match "imessage v#{version}", shell_output("#{bin}/imessage --version")
    end
  end
end
