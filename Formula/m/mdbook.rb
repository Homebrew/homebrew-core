class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.40.tar.gz"
  sha256 "550da7ff02ef62c60db6e813b6dbae65b9ed3d491186ea74929536feaceea94b"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c307bedaa0b8a8da66de509090a253265013bf0941ff880b968ac4949b9f301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de768491d1722ae1216aa8762d97e918b92574f145726d4165e6f1bd6e591137"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1775bcc2b1ffa7804ba02fc1e0cc89f0cc4ac5ebfd94feb862bac64651c63a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15f906316765f4c739c35a789d183e62e8a2c5224e5b6b53d3ea54bd413709d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e26e5f383147047c1cbf6835c881780182807432d3e1a205fecd832d01e30ba2"
    sha256 cellar: :any_skip_relocation, ventura:        "b7c941a4bebd6d86740e4efb0cc608cf47ec61aa712494e82089eeac37c79ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "c54a28f0ca20468ef39150831cae3e031754c7b9bbcb8f038414c647e24eb3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "830dc6a4a5448d5c1305adc27012f36474f5517393400aa7d7b4c15c191f18a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
