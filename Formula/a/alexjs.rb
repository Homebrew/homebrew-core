class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/refs/tags/11.0.1.tar.gz"
  sha256 "0c41d5d72c0101996aecb88ae2f423d6ac7a2fc57f93384d1a193d2ce67c4ffb"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8e7666f1bbca1055363b542c7937cfcfdcf2ce1667f8e01a3013353a0b32ab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02502faa257c0027e461b00a8f802c5bb60de704c3f75afbc09aa41b51763d71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02502faa257c0027e461b00a8f802c5bb60de704c3f75afbc09aa41b51763d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02502faa257c0027e461b00a8f802c5bb60de704c3f75afbc09aa41b51763d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8eedf8b9395fadd7cc1dd2011a9a31043acda33dd864bd214fa6457edb62a5f"
    sha256 cellar: :any_skip_relocation, ventura:       "b8eedf8b9395fadd7cc1dd2011a9a31043acda33dd864bd214fa6457edb62a5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08e51dfcc87a621c5b02f9d4ce9e92b571bc9a7659d53f75d2f66ac55d9f84b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02502faa257c0027e461b00a8f802c5bb60de704c3f75afbc09aa41b51763d71"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
