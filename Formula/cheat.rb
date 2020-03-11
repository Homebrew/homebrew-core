class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.7.0",
    :revision => "ce27cf2cc0ffdb4950ee7664b8b673be1f1dc646"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed808bc433039e37248800f8cdb3bcf131404981806cb039a9cdc86a2f01f575" => :catalina
    sha256 "5982d0f2f6477de5fa58efbbd4c64a686e4ddf31b423bcb49712ec55aca2b265" => :mojave
    sha256 "c8357412a3f8ecb5042b93d8e80c03e70138bb20d9c99c6bea28914093e4736f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
