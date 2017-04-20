class Agrep < Formula
  desc "Approximate GREP for fast fuzzy string searching."
  homepage "https://www.tgries.de/agrep/"
  url "https://github.com/Wikinaut/agrep/archive/master.tar.gz"
  version "3.41.5"
  sha256 "b15ffb7319d8e7ec302b45d6693479a41f97c4a4f66500d30f65388620c4e24c"

  conflicts_with "tre", :because => "tre also ships an agrep binary"

  patch do
    # Fixes compilation errors on OSX but is unmerged since end of June
    url "https://github.com/Wikinaut/agrep/pull/11.patch"
    sha256 "4fc6a0f4a624d8345106f277a0efa2e0ba2f62a5db399c4f1e5699d91aff697e"
  end

  def install
    system "make"
    bin.install "agrep"
  end

  test do
    assert_equal "Grand Total: 1 match(es) found.\n",
      shell_output("f=$(mktemp \"${TMPDIR:-/tmp}/test.XXXXXXXXX\"); echo $'Foo\\nBar' >> \"$f\"; #{bin}/agrep -u -s -1 'Fool' \"$f\"", 1)
  end
end
