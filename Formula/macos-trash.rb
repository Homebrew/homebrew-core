class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/1.1.0.tar.gz"
  sha256 "31c09d385bb50b0f76818a1fe2c850cf56b9575c9fa27ea963cba38dfaba7d04"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5962bfd5851549b6a251dc4b9632794622af126175faec6a4d97468d45de22c6" => :catalina
    sha256 "030b17bc67400a3f0873bd6983954fe0b55166b26c764e77b1d8cd1adc1bc1b7" => :mojave
  end

  depends_on xcode: ["11.0", :build]
  depends_on macos: :yosemite

  conflicts_with "trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"

  def install
    system "./build"
    bin.install "trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system "#{bin}/trash", "--help"
  end
end
