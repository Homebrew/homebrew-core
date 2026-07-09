class GitSsh < Formula
  desc "Proxy for serving git repositories over SSH"
  homepage "https://github.com/lemarsu/git-ssh"
  url "https://github.com/lemarsu/git-ssh/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "f7cf45f71e1f3aa23ef47cbbc411855f60d15ee69992c9f57843024e241a842f"
  license "GPL-2.0-only"
  head "https://github.com/lemarsu/git-ssh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1a478cad17df51fbe151f43ac6288cbfd5f61f79dfd049ea1da9e62d5f11a169"
  end

  deprecate! date: "2024-08-03", because: :unmaintained
  disable! date: "2025-08-03", because: :unmaintained

  uses_from_macos "ruby"

  def install
    # Change loading of required code from libexec location (Cellar only)
    inreplace "bin/git-ssh" do |s|
      s.sub!(/path = .*$/, "path = '#{libexec}'")
    end
    bin.install "bin/git-ssh"
    libexec.install Dir["lib/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-ssh --version")
  end
end
