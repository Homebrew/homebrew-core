class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.47.2/source-code.tar.gz"
  sha256 "4165bde13196fefacaa5e6bd88c4246f62cb75aed52c9ce6a7982b1e280cebe3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da2281c6004851d8f57a4153c8e082a29659ee1b3612dd3d6ff972d503a31f4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce7f760031b46332962202d853585497b94b3300dda7c5bbb49303a021801ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b62e34a5f58bc6fe8ab10e04cb484048b6aa2a49cac5d58e50a2aa3b49f3af"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac1eea3cff43228a57dfada05ac4c6a28f6c4cc7de6b29d05831b6e6182560fa"
    sha256 cellar: :any,                 arm64_linux:   "f04f43c8c41ff3cd0387fd6e48ae7f8a6eaa7294d2719339fc50ea52c90d6327"
    sha256 cellar: :any,                 x86_64_linux:  "9439e2766cd3a536ebac833091a3814159cedaabd34276c782988445711a1149"
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
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
