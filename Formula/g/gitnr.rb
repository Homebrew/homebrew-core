class Gitnr < Formula
  desc "Create `.gitignore` using templates from TopTal, GitHub or your own collection"
  homepage "https://github.com/reemus-dev/gitnr"
  url "https://github.com/reemus-dev/gitnr/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b8e15c00465b20df576bcb68a13cdb9e9afbfc908208c47cd51d3d3a62164b27"
  license "MIT"
  head "https://github.com/reemus-dev/gitnr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "494ca6dec62622f6a21fcb8c6f35ba5e125e5aed2efa9f3c31ad9cbf3536e229"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebed9b4a162160145612f92dee63eb5ca070b79fac981c88081d1d0ce63ab9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f5982f311a61d7438d4a09473a1b0f76f7d746b8e2d36975b61815ceff00e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "52f8cae5b076f50a940e44a114d385475ee9678601aa007e77cfbefdafb73f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868a9851e7d7199029195cddaf7e34fbf849b197d10e24b75497936a6d385df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e5b49b99fa4499d6f75e46c89f965ed488c956841c4f2d349ce1596c9b1b80"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"gitnr create gh:Rust"

    system bin/"gitnr create gh:Rust > #{testpath}/.gitignore.rust"
    assert_path_exists testpath/".gitignore.rust"
  end
end
