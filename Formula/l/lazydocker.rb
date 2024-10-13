class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.23.3",
      revision: "152b36577137fd95f288e12cee5fd6d857a2d101"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b280bb9358ad1d7d14820c5893febffd08dfcc30321d8b2160cd7d569f77a899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ac07f29a414a814b0e2a04a00f707693d40d18e8994865b89d99cc7070456af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d85ea08089170411b0ffbf3da83abc5f70d54a389a7cdc58c74bed33175f0b35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96ba766778d35904eba6a4197d6258e74ab901a2474233012352ddab7e11af01"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4daf142e5877778b5018303438b33b69338b2ec5381dc8690e3ca884aea8d97"
    sha256 cellar: :any_skip_relocation, ventura:        "2ce62481bbc32499d8f33fe76d0240c8b6171cf43156e68c8517ad897ddb3e1a"
    sha256 cellar: :any_skip_relocation, monterey:       "0bb1743aae637e317ed37197bce584b49604fd88967403c4dcac083adb3efac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7670ea3478aef62147ec682af8df6ea24ee4fcd7b4e1dd26aad6bfe437f06bb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
