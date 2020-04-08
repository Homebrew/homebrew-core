class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/3.9.0.tar.gz"
  sha256 "404081005628cccbbe576567cf3aa1e8d93c618230c9119ae74ce27366cddb1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "18edf4066c081f71bebe977b79b76254cbda30c00c075a299fb8f117d5eba52e" => :catalina
    sha256 "2e36284e2c7fed7290151a4c1eb056e0113c95219de7b79604eccd4332a5f5c8" => :mojave
    sha256 "7be1ba84ca206fcc9178a1afb216f1b43d3e2575f1ad53bacf52b355262cee56" => :high_sierra
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
