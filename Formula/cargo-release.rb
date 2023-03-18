class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.6.tar.gz"
  sha256 "5d64e2d269b2e396fe7c421c69b7fa9e80cb24e8edcbaca2810601f8d7e88617"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6dfb1ce9c9b3ada66d8be39b84d38cd2b252c313ea689432f19efc68be9d3e4"
    sha256 cellar: :any,                 arm64_monterey: "737e2a09a15ca5de83397b4e25261168e253fc73764e2be0dd19a95f1d853fbb"
    sha256 cellar: :any,                 arm64_big_sur:  "6200eda597da3edb28d71335ceb4db59318d2efcfadc26c34b4a116dccdabb73"
    sha256 cellar: :any,                 ventura:        "941fac1461f781bf8637b68301b2493b559d63acb14b14c24365d965ca58837d"
    sha256 cellar: :any,                 monterey:       "622eed1e618b5b81a7a09128670a17018ecb00848094970193008df467072743"
    sha256 cellar: :any,                 big_sur:        "e19c9701a43b453bd815f7cbc64eee4c62c8743e49dcb105a2206169553b2020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60e551e1fe24b8931ed8dd5603168d0a0e5d7bf3e13e91ac490a04010a57662f"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end
  end
end
