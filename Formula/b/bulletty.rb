class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "5c5cc4065e2b9529a7ac2262d4fbc7355065ae3d632dead7dcfa7e3ed385c304"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6482ba9398289b737fb63caff2c98d8e5a9218ea1ec47bb171e96006bdef306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3dd174afb745d6a6367a298015213f487e769b4a637d5e8beb7c8d3dac2d676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba64d062ba66d67f672a62e38bdc7f51d35421bf1a3014361c8cc3835ff8c875"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b10f61ac10ac7d72e0414f94d86b8c130c4cccdbd116fe8bfb5703d1d7c7114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f05f5bf8ad1d346fdafbe490c0127e58f264fbc476eb1820ddb477bdc5d35abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1a01b886f05e1f9278518ec2809b2fe2ca150d011982dc3eab48ebb5ea1dff"
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
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
