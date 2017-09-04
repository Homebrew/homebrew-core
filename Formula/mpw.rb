class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"

  stable do
    url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-1-0-g895df637.tar.gz"
    sha256 "1b7992dcab2538cfd403ccb8645d69ae419dfedbb03b38515508af3e814c8164"
    version "2.6-cli-1"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "03d033152f2da377654b0dabd823e304827fad58d08ab3c945978f61c5aba5bf" => :sierra
    sha256 "23055a80705a261f15bf1f36cce7919dda62457b06c4af1bc1137ed172aa6844" => :el_capitan
    sha256 "34b22632d5d225bcbc6b24dada0ce2b526c6739b9b0e55e9b1209f265d0a6888" => :yosemite
    sha256 "290586cc77c94562e08977227209e16b9b821cb84e068bcf748b2e0ce07bdb0f" => :mavericks
  end

  head do
    url "https://github.com/Lyndir/MasterPassword.git"
  end

  option "without-json-c", "Disable JSON configuration support."
  option "without-ncurses", "Disable colorized identicon support."
  option "without-libxml2", "Disable test-case parsing support."

  depends_on "libsodium"
  depends_on "json-c" => :recommended
  depends_on "ncurses" => :recommended
  depends_on "libxml2" => :build

  def install
    cd "platform-independent/cli-c" if build.head?

    # Features
    if build.with? "json-c"
      ENV["mpw_json"] = "1"
    else
      ENV["mpw_json"] = "0"
    end
    if build.with? "ncurses"
      ENV["mpw_color"] = "1"
    else
      ENV["mpw_color"] = "0"
    end
    if build.with? "libxml2"
      ENV["mpw_xml"] = "1"
    else
      ENV["mpw_xml"] = "0"
    end

    # Targets
    if build.with? "libxml2"
      ENV["targets"] = "mpw mpw-tests"
    else
      ENV["targets"] = "mpw"
    end

    # Build
    system "./build"

    # Test
    system "./mpw-tests" if build.with? "libxml2"

    # Install
    bin.install "mpw"
  end

  test do
    # The URL's package provides a test script for the mpw binary but I'm not sure how to run it from the `test` block.
    # system "./mpw-cli-tests"
  end
end
