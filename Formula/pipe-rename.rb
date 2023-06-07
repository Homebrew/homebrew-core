class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://crates.io/api/v1/crates/pipe-rename/1.6.4/download"
  sha256 "02043732ad9b47b2c2485599ef7b6e3bb8d23b13ef7362ee4c16ef32e39815d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "729b0936daa03d43e53600d92a2dcc6e09e56c9df2b0c375f2ca9556fe8ba5e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9933a66e3546b0540ab7b13024e2b50ca929a07a90026d37345533103aae8522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10e9a8bc5567dcf7cbae81a04e0e1b8456344bc33f7820b87af9c710e6dd70be"
    sha256 cellar: :any_skip_relocation, ventura:        "5a73c2c48ac30277083a127920b84070a396dcc4585fc5ca473a2ecbb8a515ce"
    sha256 cellar: :any_skip_relocation, monterey:       "6cf9943f37e1bc165c330c65bf63f31bbdabe5f43822cb71c5b8857b31705544"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5771bd177d367df7d7b6ddb6a19aea870c21ffbcb8ca310885f41bd1b217fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9deea1ef250974a8d4265f10c523e301476388861e23a3f2dc98747be70dd7a4"
  end

  depends_on "rust" => :build

  def install
    system "tar", "xvf", "pipe-rename-#{version}.crate", "--strip-components=1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write "#!/bin/sh\necho \"$(cat \"$1\").txt\" > \"$1\""
    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system "#{bin}/renamer", "-y", "test.log"
    assert_predicate testpath/"test.log.txt", :exist?
  end
end
