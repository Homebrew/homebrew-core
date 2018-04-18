class Clac < Formula
  desc "Command-line, stack-based calculator with postfix notation"
  homepage "https://github.com/soveran/clac"
  url "https://github.com/soveran/clac/archive/0.3.2.tar.gz"
  sha256 "37a926982a3cc5016b42c554deaa5c64fa3932ebacd5bd15003508cf79a666dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc5ecef046a8795d26192fab39253fc07692f16fcd456e9fc8e06e621d760c1d" => :high_sierra
    sha256 "cd5a4f0ec0632c5b075b4183b4928b31c20899aef74fe0f481c4ffeb123c7068" => :sierra
    sha256 "9c084fb7bf7246c9f6e02dc44c90ba51b97d58c76ca59c1f217a183d87d71211" => :el_capitan
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "7", shell_output("#{bin}/clac '3 4 +'").strip
  end
end
