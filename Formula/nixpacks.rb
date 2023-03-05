class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "43604a5c0734386643bdf481e43ca513228a88280081829f7f5b5a031a82a7eb"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7c16929c8c5ddfb82635df0bf61c1885a68f9a0a2680105fb6c668beee000d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b19a23ea955746c96bfd00a7dc74df692974ef6b549616fe6be2a1aad30076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f592f1f56bcf2d23c4d0d66339cb180798f628c34f81061ae795e1263098bb"
    sha256 cellar: :any_skip_relocation, ventura:        "69fc840e82690d14fab360a76ed8ff7074e6a0687844ad7527fe561bd9c444a6"
    sha256 cellar: :any_skip_relocation, monterey:       "2a7484c79c0390e8153da1b90ffc3fc581f729d2097f07c05dc7428761a74a2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e6054b22bc7115cce634c9d83db9931af81c084d125aa963ba572e6202fa676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4f61b48da9d4264f0b8c3bfab4ba1c5dc3210ef7f9fd60d15e7a78805f76bfa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
