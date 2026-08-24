class Committed < Formula
  desc "Nitpicking commit history since beabf39"
  homepage "https://github.com/crate-ci/committed"
  url "https://github.com/crate-ci/committed/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "416aab32bf0cc2012259ee3ba264f3db0493164272694c6c4bef15e9258d4244"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/committed.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d7c4964ba5f02e337add48870263525ab618dda39c5e69d8e51dc03320771d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4aced867d8d33a939457f3e171800d2fc996e558da920956c0ff8088d7154eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef02f7b8ab4411a9fb0ed02e74abc573aa596043dce6bd30564df80157f9eff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "452aca8c27ab273d9acffc134b3b2bf8e059fc7918cd9d9e3ad8af951a8668fe"
    sha256 cellar: :any,                 arm64_linux:   "06366f236d9d86d4370a9cf65c58a74aa8499a34ac5e09e676e50621aa59d525"
    sha256 cellar: :any,                 x86_64_linux:  "f1846d0480f02007eabe6bcf1fb99f37e00d0fe526b724a3baf52976d2306a06"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/committed")
  end

  test do
    system "git", "init"
    system "git", "-c", "user.email=a@b.c", "-c", "user.name=t",
                  "commit", "--allow-empty", "-m", "bad message"
    output = shell_output("#{bin}/committed HEAD 2>&1", 1)
    assert_match "Subject", output
  end
end
