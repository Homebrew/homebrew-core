class Committed < Formula
  desc "Nitpicking commit history since beabf39"
  homepage "https://github.com/crate-ci/committed"
  url "https://github.com/crate-ci/committed/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "416aab32bf0cc2012259ee3ba264f3db0493164272694c6c4bef15e9258d4244"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/committed.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0ba1b869ec35634f88a7be9be9681495649044c783de5a8919aafe3ccc08545"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d0840a3cd73a541795542ce7cdc7ebc068d3988f04f100e52a4a6726c13d8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "943b0bd708823ed8a4111ac9b6279493d975f9490b4468f01699920f8e971302"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff58466048d4e980b120aa381e8fafca7fc15f4317c088b2dd9e8f10922442dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d629fdb8f4e20bdf7577b37ba53dea36fe7702c0db4c0682ad09f5cf939d4238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289b4fffa6f5339cd7e6e6a0e9c04bce7b82e762acbf244646468630e4140088"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib"
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
