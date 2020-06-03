class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      :tag      => "v1.1.1",
      :revision => "5864a3b4a79f490acb407f242844212b6a943d12"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a15917da1948f7a5469f881cd034dddbb34e4fea983ff794f909e475928ee59" => :catalina
    sha256 "a751ce342e164b78e14aeb399d8ae7c839ac07c99b1b2c9f821d229e80eef588" => :mojave
    sha256 "ec0a8ed39c611bca601fa216520f57bd4bd35bea0ccf960931c01179b166a224" => :high_sierra
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
