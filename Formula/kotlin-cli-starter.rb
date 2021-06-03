class KotlinCliStarter < Formula
  desc "Git extension to generate reports for standup - in Kotlin Multiplatform"
  homepage "https://github.com/jmfayard/kotlin-cli-starter"
  url "https://github.com/jmfayard/kotlin-cli-starter/archive/refs/tags/v0.3.tar.gz"
  sha256 "bbfaec0b9ed0918feeeed02036e8bddfd5d028f11e09fec8e9af1361a3eaeace"
  license "MIT"

  depends_on "gradle" => :build
  depends_on "openjdk" => :build

  conflicts_with "git-standup", because: "it's a reimplementation of this tool"

  def install
    system "git", "init", "."
    system "git", "config", "--global", "user.name", "Git User"
    system "./gradlew", "macosX64Test", "linkReleaseExecutableMacosX64"
    bash_completion.install "completions/git-standup.bash" => "git-standup"
    fish_completion.install "completions/git-standup.fish"
    zsh_completion.install "completions/_git_standup.zsh" => "_git_standup"
    bin.install "build/bin/macosX64/releaseExecutable/kotlin-cli-starter.kexe" => "git-standup"
  end

  test do
    system "git", "config", "--global", "user.name", "Git User"
    system "#{bin}/git-standup", "--help"
  end
end
