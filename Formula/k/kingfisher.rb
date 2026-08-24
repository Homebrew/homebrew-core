class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "9ba06e23ed6605ad28ea612d2ac82bc9ac5122ba3024798f5dc3215f60f2b317"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "627e3ad88c3afd3231da1f32f5dcb9393b3da40e08953379be9717c3be5f81a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0365c3ca46b152e0166be9e96799f930ac38fe95d88733d55248b44be9626623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "307e5a11abd066e95b502a3c09d1a5633957fb8d027df8cfee0af8fd0a9d5377"
    sha256 cellar: :any_skip_relocation, sonoma:        "03dc26981528b019cb48af0ac043c5b6666636638e089377f94c4b402ac5bd56"
    sha256 cellar: :any,                 arm64_linux:   "ae3463f1b281c44d2da9fb8f48331337937e29757ec80e9effc99d6dfcfd0459"
    sha256 cellar: :any,                 x86_64_linux:  "f3227eaa9597989aad46beaed2d241d7f19ceb17745855395c079fa8aaf36955"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
