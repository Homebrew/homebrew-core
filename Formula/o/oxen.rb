class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.3.tar.gz"
  sha256 "421e914bab830b6df2d0ebde0a3f80b26554a020a882a90bd1d2fa4cb7795112"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a76f29afa237faa116665ade122f26d967ebcc45ca20452c1c05896bc17a107a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cd0f31145f23b726ed83bd260ae9bb1553a05076c7f4d85ae84d2f5f4dbfca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7fb78e660ad665575055d26baaee6bbeab8bb14c8d6f552ddd3c85e892b9c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "917b3fb9cfb07550582b1d5e1dd1e9de7cb5b81466de36fbc88f05b1a7b89f91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fbde3c352bdb6ff10ce40d46b91d4e8d3f4a72bbea095c6109fc53ca05d6eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51eb63141f5c3f89ff1b24d7f2578c533516d095ce15eb9a4ff8093c50c63d8a"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "crates/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
