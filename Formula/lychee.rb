class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.7.1.tar.gz"
  sha256 "f6acf92987aae006273b5fd211cb5c6a2f30036b7fd69ac36ecffb2b28cc3101"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ef9c905779258881a49a492d250422c5b3c5d7564fd30a7273b89ed79fdc0433"
    sha256 cellar: :any,                 big_sur:       "82f1909185e475cf9c373e49772f869e2bd97ba867485cbe63a4e2424b0abba0"
    sha256 cellar: :any,                 catalina:      "80e63594eb599cb688b13dc483ce3ca8ae24d7c5bc6ef35337914a9577fef160"
    sha256 cellar: :any,                 mojave:        "26b8aeec96efbea9c8cd2966a0f58c6d57ced02d0b4f9a5b86b58992062ef247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da3098c89bc54301f1e2622ef178cc47366aa56a9d8068e153e77ba01693756"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match(/Total\.*1\n.*Successful\.*1\n/, output)
  end
end
