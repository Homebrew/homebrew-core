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
    manifest_sha256 "70ca45a90d7625960814ae67e150fc2d45ccadb14b575e6a09488f8941fdc6fc"
    sha256 cellar: :any_skip_relocation, all: "7e0b2d0fd153d90a266ad1444f60bc209dc603f09d25ef81328cc9b4988649b9"
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
