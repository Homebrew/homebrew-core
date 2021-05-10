class GitStandupKt < Formula
  desc "Git extension to generate reports for standup - in Kotlin Multiplatform"
  homepage "https://github.com/jmfayard/kotlin-cli-starter"
  url "https://github.com/jmfayard/kotlin-cli-starter/archive/refs/tags/v0.1.zip"
  sha256 "ee568d395a637d4cb16846c63835e76a6ffb562dcf39895a49eeb28d23bfdba3"
  license "MIT"

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on "git"

  conflicts_with "git-standup", because: "it's a reimplementation of this tool"

  def install
    system "git", "init", "."
    system "git", "config", "user.name", "Git User"
    system "./gradlew", "nativeTest", "linkReleaseExecutableNative"
    bash_completion.install "dist/git-standup.kt.bash" => "git-standup"
    fish_completion.install "dist/git-standup.kt.fish"
    zsh_completion.install "dist/git-standup.kt.zsh" => "_git-standup"
    bin.install "build/bin/native/releaseExecutable/kotlin-cli-starter.kexe" => "git-standup"
  end

  test do
    system `system "#{bin}/git-standup", "--quote"`
  end
end
