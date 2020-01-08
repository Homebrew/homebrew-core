class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v1.0.1",
      :revision => "91944fb60fb534d7cef338162baf64e3d20aa6a8"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb088688adb43e67125bfba1c7fb54ff006dfa8ea160733a63462950091f3688" => :catalina
    sha256 "0933c685f2987768ac9ee64676212efb721b25ee1bc96d3ed406bef163687ad9" => :mojave
    sha256 "e74d5044486593192e8c3b5009aec3b580ad03b354e3a7f06ba01e2da1613f17" => :high_sierra
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
