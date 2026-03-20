class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https://github.com/mufeedvh/pdfrip"
  url "https://github.com/mufeedvh/pdfrip/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "e75bb5bcc2b58f80189dd10ba18e3cb8673935316172b8bd7a63822859cba11b"
  license "MIT"
  head "https://github.com/mufeedvh/pdfrip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5856a2f08d97cb02cfca8c54d867f4265ca284b864ec7c7818c3a3beb4523a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f70dca6d1b3856a4082fc53d5532cdd89a827109475fc856c9f63e4623de35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db92291f34f5c62fbf965660d077527b507d34d7f0bc4c43465fdcb515bd434c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5e175aa463c916e4ad738afdde1454cad704e10ab03c7eeae7b3ab2e1ff062a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c56527b7206b55fa93791339360963c87a49e8f7af73d617b65b985c3617b852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc702689e1725749aef7fa49952a53a740a1e21ca15032928d97d3ed3933c2a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfrip --version")

    output = shell_output("#{bin}/pdfrip -f #{test_fixtures("test.pdf")} range 1 5 2>&1", 1)
    assert_match "PDF is not encrypted with the Standard password-based security handler", output
  end
end
