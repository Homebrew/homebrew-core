class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.8.0",
      revision: "406c7dc8d6bc3f8687d653e9440092ca6ddf767a"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9450da5cf189567a538d0f1f4de3e6712956481673f5938ee8ffd68fab6bf9bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbede11861022d26b16bcd7fe1582ac105949823f816c80630ccc1cd89643257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09d181823233e866a586656a0712c9e353f212b90ca01c83d413efa49bddf9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5950bbb06ad0a7ce292f048f96db4800e9cb6c6a1c9d3606d5456eed14e3f7e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b384e83c4c94b5242ef0df0e612ec2007527e3bd85dfa0fd2f2776e1888b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0103811f16487909de79160172cb13679632728a8b88078bdcfe52fd272726"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
