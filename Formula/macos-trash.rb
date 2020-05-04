class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/1.1.0.tar.gz"
  sha256 "31c09d385bb50b0f76818a1fe2c850cf56b9575c9fa27ea963cba38dfaba7d04"
  head "https://github.com/sindresorhus/macos-trash.git"

  depends_on :xcode => ["11.0", :build]
  depends_on :macos => :yosemite

  conflicts_with "trash", :because => "both install a `trash` binary"
  conflicts_with "trash-cli", :because => "both install a `trash` binary"

  def install
    system "./build"
    bin.install "trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system "#{bin}/trash", "--help"
  end
end
