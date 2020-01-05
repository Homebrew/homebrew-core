class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v1.0.1",
      :revision => "91944fb60fb534d7cef338162baf64e3d20aa6a8"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57ea173e1d0d494afe7ef12a43f35a2708f9d03cd716b525b2e62463540977a9" => :catalina
    sha256 "499b1fb499d026a15a631cf28329e6aa2dcd53d365fe9c5286101869259307ad" => :mojave
    sha256 "2659bc626482980f67f5fa5e62e55a68db38011bc8c5e696e5e344359858580f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
