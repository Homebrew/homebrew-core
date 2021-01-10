class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/v1.1.1.tar.gz"
  sha256 "e215bda0c485c89a893b5ad8f4087b99b78b3616f26f0c8da3f0bb09022136dc"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b0b3fd96b400200bd92f734643501247fe2d3c5b2e063017c0d6aeebd337567" => :big_sur
    sha256 "8d9db5fd2a2fcc20b593473a91f34b21fb7df149fbbd1075497aba0922118e51" => :arm64_big_sur
    sha256 "5962bfd5851549b6a251dc4b9632794622af126175faec6a4d97468d45de22c6" => :catalina
    sha256 "030b17bc67400a3f0873bd6983954fe0b55166b26c764e77b1d8cd1adc1bc1b7" => :mojave
  end

  depends_on xcode: ["12.0", :build]

  conflicts_with "trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system "#{bin}/trash", "--help"
  end
end
