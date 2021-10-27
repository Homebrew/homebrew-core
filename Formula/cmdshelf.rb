class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.2.tar.gz"
  sha256 "dea2ea567cfa67196664629ceda5bc775040b472c25e96944c19c74892d69539"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48c85f481fec33421ae5742578ee00215b18214a8268a691bdc30950972cd22d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f40147d57994d19a28f05ef6bcb1c3f3382d17d46df244f34ed32e611de5729"
    sha256 cellar: :any_skip_relocation, monterey:       "b407895fb2f008bed03829d02ede8b966523112684971682dfa40991cb5f6b72"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6f07a011569e722624d846203a87807a5eee4dbbade4cd8b8d92f0b071ea884"
    sha256 cellar: :any_skip_relocation, catalina:       "e4093bda9528ae027e122f321e2f1a44d3b4fc8b569e2bf0eba526399cccdacd"
    sha256 cellar: :any_skip_relocation, mojave:         "4c83af8661b368f727a389f12d434be45655d10aef9ae1acb8b2be830aae0558"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c0cdc78df3f3896e4e8ba2112ec6e5189682da06419637ebfa9d660ff4fb902f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ba139776fd2403b480ca2f54f4abda07bf141c0efb7b40c6098ff487e2fd76d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man.install Dir["docs/man/*"]
    bash_completion.install "cmdshelf-completion.bash"
  end

  test do
    system bin/"cmdshelf", "remote", "add", "test", "git@github.com:toshi0383/scripts.git"
    list_output = shell_output("#{bin}/cmdshelf remote list").chomp
    assert_equal "test:git@github.com:toshi0383/scripts.git", list_output
  end
end
