class Orogene < Formula
  desc "`node_modules/` package manager and utility toolkit"
  homepage "https://orogene.dev"
  url "https://github.com/orogene/orogene/archive/refs/tags/v0.3.34.tar.gz"
  sha256 "d4e50c2c3965e62160cf6a15db3734e4a847ca79629599fdd5ce30579aaae9a3"
  license "Apache-2.0"
  head "https://github.com/orogene/orogene.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d1b71b12add1cf3f8217e5d857e056c54a004638ad178be9f71ed0e7d55a0e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "68164cd2ef24f2cc58c5562c7c81cb72bc9139ef96975f459f1bd6ce05c3e73a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7a9c9b9ca6a84e14304d3d5e1f5fcb8d44d7546c0fe635c14e3bbd468175421"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1279bf1b9a1d443e8e4e5173be1e015438c0c3c0fdaa263879209fbd9fb8758b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e223abe73a6f15d8ae775209bb721c9a9513b4edac55af8b5f463587802039a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e72c4f89a0517891879aab76a95a3f12b9055d1dfd8510275bb5211883153c52"
    sha256 cellar: :any_skip_relocation, ventura:        "f94a9aa11660b3e6ad47ba48c38fdd988a8a51435ed7e6f1533983d5b939a66b"
    sha256 cellar: :any_skip_relocation, monterey:       "eecf977924a2d78a5b4871f5a58b3ea1733aa5b918849d743f0c2f1d9aec0e79"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f8fb64cd8e5659c0d3f72fe6c994248c8e7c7c63af9e8a1b5801df5e5e73b13d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead950a69b6ee4a7d7023264f55372d0d84e83984c46af445280d8f5281871fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  # rust 1.80 build patch, upstream pr ref, https://github.com/orogene/orogene/pull/315
  patch do
    url "https://github.com/orogene/orogene/commit/2f774bb5b1067fb0f5f827140aff328190af0452.patch?full_index=1"
    sha256 "c91711588a6fddee3055a356723a8a044cd82d287c59a7cf83802129d2ffa89b"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oro --version")

    system bin/"oro", "ping"
  end
end
