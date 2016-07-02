class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/2.1.8.tar.gz"
  sha256 "25b002f1df34ecc31c0a254ee95bf077dd4285a3d428a48e5d4821c289795800"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9383bd9b3ad0be1c8811c043c990380e448e0c7c97026824aaafaf79693452c8" => :el_capitan
    sha256 "08e5790403f65d6647af1ac61836e8db95a139530203cc0ac28b9da3d058b24f" => :yosemite
    sha256 "fc7c28d7ea966ce3918a5b26e6be80e2fd9bfc515bb264a32c1c0afafaef865b" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "#{testpath}/test"
    system "git", "commit", "--message", "test"
    system "git", "standup"
  end
end
