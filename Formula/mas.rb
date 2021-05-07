class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.2",
      revision: "2f2a43b425498f3cee50974116b8c9d27adbb7cb"
  license "MIT"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f5ef4f44057f43ecc14f970687d832bd152bc6142c0ad848977f0a6527aa934f"
    sha256 cellar: :any, big_sur:       "d92cfc734e730fde87b29c6bf4a50ce63a78b9e505f464dc557eee128aa06d05"
    sha256 cellar: :any, catalina:      "163eb9cfdfed3d8fbda133b4079d104ad687f1ddb71d70d5661d02b22f562e76"
  end

  depends_on :macos
  if Hardware::CPU.arm?
    depends_on xcode: ["12.2", :build]
  else
    depends_on xcode: ["12.0", :build]
  end

  def install
    system "script/build"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
