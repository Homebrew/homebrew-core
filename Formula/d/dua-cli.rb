class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "e7cb52b4dc6bf89a554b0f1292344eafceeace1cbf957a2c0942bf1201b404a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "757cc4d0c36a61b8997cafc441891febe9aebfab9c31061da3bb6eeee57ed6b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c0cafb929368a37b064bbe654badfec69e81591bc64fc709a884206f4ec5201"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba47ae7e44a346ed1e8e93d10a4ddb9e231105ed277416c555543c42d1d0a104"
    sha256 cellar: :any_skip_relocation, sonoma:        "8092bcc37112ec20f690a9e41bbf8712d7ce85c3b63d33d9bbd4096c2e9d0ade"
    sha256 cellar: :any_skip_relocation, ventura:       "87ed8692edf0f3ed5e72ea186dd201f1fadb8c81ed0730878e9ed1154f4f4505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0634654442c4307b6cbdf27f43736b8f407848294163718a68c7cdaf8eaed16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6222a1aa0caf02ceba9a9786a816bb99f4291e39507b38d399c4fc5b1b2ed2ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
