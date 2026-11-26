class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/13.1/BaseX131.zip"
  version "13.1"
  sha256 "0f99e7aacb978e444525d49d3778ac55b22429bfe11c3a2b17daa825760b688e"
  license "BSD-3-Clause"

  livecheck do
    url "https://basex.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/BaseX[._-]?v?(\d+(?:\.\d+)*)\.zip}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c640e86b5910331095db84c365e640bcd806878cc7c7009726a0dc89e517d23"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    rm Dir["bin/*.bat"]
    rm_r("repo")
    rm_r("data")
    rm_r("etc")

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", JAVA_HOME: dep("openjdk").opt_prefix
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n", shell_output("#{bin}/basex '1 to 10'")
  end
end
