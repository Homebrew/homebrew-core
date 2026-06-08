class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.50.4.tar.gz"
  sha256 "302f1e077cd3f4caaa8744df5cab959439f20e6620f7978e092419692526e098"
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
    sha256 cellar: :any, arm64_tahoe:   "058969235ad9e5098d855d4943ac7f74008f069dcb328ebe977a30bb0b3975fc"
    sha256 cellar: :any, arm64_sequoia: "006051d874a277b29814d41f0b99333ee6bf2a34c04a966d8595ca563a919831"
    sha256 cellar: :any, arm64_sonoma:  "18149fa5479498ac95d1b621daba48c1aeb27aa3bb269d688861a0cf75679bbe"
    sha256 cellar: :any, sonoma:        "4238a7959f5e6b700adfc22a0e975d3d564fa4c230fd67ce11b486920903b3ad"
    sha256 cellar: :any, arm64_linux:   "d80f1daf7bb04ca86c160e004ce10249ae3745c68f060192f18701c8cd8c933c"
    sha256 cellar: :any, x86_64_linux:  "8018400e5ac4cf4b48aac2f4bc0e65a0c10df912bfe4fb4947be57f4bf5e9e1e"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["ROCKSDB_LIB_DIR"] = Formula["rocksdb"].opt_lib
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
