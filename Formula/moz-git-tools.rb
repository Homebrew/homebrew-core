class MozGitTools < Formula
  desc "Tools for working with Git at Mozilla"
  homepage "https://github.com/mozilla/moz-git-tools"
  url "https://github.com/mozilla/moz-git-tools.git",
      tag:      "v0.1",
      revision: "cfe890e6f81745c8b093b20a3dc22d28f9fc0032"
  license "GPL-2.0"
  head "https://github.com/mozilla/moz-git-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99c55678ff5156827bc42fe79089d693c196375a77872c071e65dd9c295b308e"
    sha256 cellar: :any_skip_relocation, big_sur:       "8277513f9379b1f04919d70ab3998f15a4b7003ecf5a370ce6ffdeb3ec60f813"
    sha256 cellar: :any_skip_relocation, catalina:      "2bd3c22ef9b16601e84d060db320ca9f0a3ad8713a0a8a1274446ea35c418d0c"
    sha256 cellar: :any_skip_relocation, mojave:        "101a581f5a39b97b8e6742bfe6d3eff742c590427ca07c768751376530bcb54f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "0901261be02f9a82cd6ab1b287160e047c4160d81a443f4edc0a7326fdf08a6d"
    sha256 cellar: :any_skip_relocation, sierra:        "7a771b0e71a44dafd3fc4eb2210f909d412f9ea541a7ff50a96ce272204cc501"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c5ddb2e842a6fb26ba5feacdee6bac287d94732abd888bd11bc5c80be4f100a4"
    sha256 cellar: :any_skip_relocation, yosemite:      "91f89ec1014d6c7b395571210c0f21b1e701f4bfb90540a94fa3daafd4472d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01829ab80b5413ab1328753946c6910fe0bfe7e9153bef06efbbd6b457e3b66f"
  end

  def install
    # Install all the executables, except git-root since that conflicts with git-extras
    bin_array = Dir.glob("git*").push("hg-patch-to-git-patch")
    bin_array.delete("git-root")
    bin_array.delete("git-bz-moz") # a directory, not an executable
    bin_array.each { |e| bin.install e }
  end

  def caveats
    <<~EOS
      git-root was not installed because it conflicts with the version provided by git-extras.
    EOS
  end

  test do
    # create a Git repo and check its branchname
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"myfile").write("my file")
    system "git", "add", "myfile"
    system "git", "commit", "-m", "test"
    assert_match "master", shell_output("#{bin}/git-branchname")
  end
end
