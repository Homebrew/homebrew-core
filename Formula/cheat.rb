class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.1.1",
    :revision => "a7067279df82eaea5e9f5fb7cade774f35587ddf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2e1b945d1c928710864b37966d79f0761e8b3176b0e5d4a2c71946783670e05" => :catalina
    sha256 "f379301e0ec1b2d341ef144cfc3260a9082e678d7df1c5b3801ee123eab5f4bc" => :mojave
    sha256 "1fe24ca39bb1123548ce0643594a4ebfd8dcca0a94c3679ff0e743ce8dbdc51d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "could not locate config file", shell_output("#{bin}/cheat tar 2>&1", 1)
  end
end
