class Modsman < Formula
  desc "Minecraft mod manager for the command-line"
  homepage "https://gitlab.com/sargunv-mc-mods/modsman"
  url "https://gitlab.com/sargunv-mc-mods/modsman/-/archive/0.20.1/modsman-0.20.1.tar.gz"
  sha256 "09834f6b34014652e6dd46a4e3c0ecb9d353002d44053854d05faffd3efc022b"

  depends_on :java => "1.8+"

  def install
    # since gitlab's download doesn't come with the git repo, we need to fake a commit so
    #   the gradle-git-version plugin can get the version
    system "git", "init"
    system "git", "config", "user.email", "fake@example.com"
    system "git", "config", "user.name", "Fake Committer"
    system "git", "add", "."
    system "git", "commit", "-m", "fake commit"
    system "git", "tag", "0.20.1"

    system "./gradlew", ":modsman-cli:installDist"
    libexec.install Dir["modsman-cli/build/install/modsman-cli/*"]
    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # TODO: replace this with a proper test
    system "#{bin}/modsman-cli", "--version"
  end
end
