class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "f399c0fb2d60af298d8a1b968f5d3b4e8853fb8448290d193bb551635c731183"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a27f692263a73eed4b53fa0a0862dfedcc9706ef8f83101bf92c245cdaf767b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32e55dabef96576b2d7117db0659acf5f4e2134afbbdfb3789eec16bb99ecef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37ccb8a5c74c6a069f6d2f3e75b778ed204ffa80b2f3e021471223e52448d5c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "990b3829b8360648abe49e8155fe2a97035cfd3cd1058abac3d6823eeb356030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "842be46ee7e5a26dd1598b74d5f46ec3d935aff5570759c2388f09184b537f6d"
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
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
