class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.6.0",
    :revision => "b13246978ab7ebb254b49d58c625f94aa2e08ee7"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "abdc9f1adc858c1ee5490226b8528364e968d8ee3ce1499308281a270f6a5f45" => :catalina
    sha256 "d0d0dde1529433d1436e48a191fcc126dbc59d2676ea9c2e1da8625e72b1d142" => :mojave
    sha256 "22f74dcedb3db5ac7dc95b447ccbd57c816a2b0fc2736504e2ca96ab1b239b86" => :high_sierra
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

    assert_match "Created config file", shell_output("#{bin}/cheat tar 2>&1")
  end
end
