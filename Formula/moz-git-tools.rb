class MozGitTools < Formula
  desc "Tools for working with Git at Mozilla"
  homepage "https://github.com/mozilla/moz-git-tools"
  url "https://github.com/mozilla/moz-git-tools.git",
      :tag      => "v0.1",
      :revision => "cfe890e6f81745c8b093b20a3dc22d28f9fc0032"
  head "https://github.com/mozilla/moz-git-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bd3c22ef9b16601e84d060db320ca9f0a3ad8713a0a8a1274446ea35c418d0c" => :catalina
    sha256 "101a581f5a39b97b8e6742bfe6d3eff742c590427ca07c768751376530bcb54f" => :mojave
    sha256 "0901261be02f9a82cd6ab1b287160e047c4160d81a443f4edc0a7326fdf08a6d" => :high_sierra
    sha256 "7a771b0e71a44dafd3fc4eb2210f909d412f9ea541a7ff50a96ce272204cc501" => :sierra
    sha256 "c5ddb2e842a6fb26ba5feacdee6bac287d94732abd888bd11bc5c80be4f100a4" => :el_capitan
    sha256 "91f89ec1014d6c7b395571210c0f21b1e701f4bfb90540a94fa3daafd4472d3b" => :yosemite
    sha256 "8df4c14355c7b6291964609122f8643f61d77e05c2b6b68517710e5653a1423e" => :mavericks
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
    assert_match /master/, shell_output("#{bin}/git-branchname")
  end
end
