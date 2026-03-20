class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.15.2/source-code.tar.gz"
  sha256 "8c24409b41007c298e9a58c143c191b739040ee6cb24fc678d0f169d614794f2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "846c32eb9af5bbd03a517ea0142ab51e9e1216311f33a8a909f58465c97d67f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81e977ae2353bf573f3d44400103afa12bc0a4e030c57de053057c53615c17d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae48cdfffa9691f3ca6f0b5b8a393a1fac1a18a4acedf39b823c2447d34aa0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fe329160dbe7bb67f8fb3296c7a53a2ef7dde38b16d9caa784c5402f7bdc284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4628d33b548b8723d2fcfc566e1a5465c13abc1f27e926d6a748d3a27d64d504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc1c73c4a2c16756e2795a8e44dbcf02a848d5141f20508e86067e28975152e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
