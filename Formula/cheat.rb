class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.7.1",
    :revision => "521f83377ca85cf82853c985592ca5317ae9ee1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b66a8dc26d0247770989f2595b877f804f046ffd83dd3b7430978d375dfea2d0" => :catalina
    sha256 "b33144826ed3cd9906ac45710ffa39490cfd2bfec1ba9f1dc2083f2656c60580" => :mojave
    sha256 "db63edd49fb9d31d52619af9c2c1db0b758369a8bd02e1b94c9ac29eef0bf39f" => :high_sierra
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
