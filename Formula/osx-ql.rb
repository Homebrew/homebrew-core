class OsxQl < Formula
  desc "Opens files with the Quick Look feature"
  homepage "https://github.com/morgant/tools-osx#ql"
  url "https://github.com/morgant/tools-osx/archive/refs/tags/ql-0.1.tar.gz"
  sha256 "16c079be28651879325d7bec0863d61341752c2e6e1373e18cedc8e72d7c75eb"
  license "MIT"
  head "https://github.com/morgant/tools-osx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ql[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

  def install
    bin.install "bin/ql"
  end

  test do
    assert_match "Usage: ql [options] file", shell_output("#{bin}/ql -h")
  end
end
