class Aftman < Formula
  desc "Toolchain manager for Roblox, the prodigal sequel to Foreman"
  homepage "https://github.com/LPGhatguy/aftman"
  url "https://github.com/LPGhatguy/aftman/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "fb7a4fc6a0e736df3968834284da163380d4dcd4707e9836d35ff427e6c53f8c"
  license "MIT"
  head "https://github.com/LPGhatguy/aftman.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edec901a3f1f643bc4ccc95177188ad2a0c8d212724a23747e9ffef4f8cd97ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86a9b2058bf845cafce8ee82042de17723a1642bd83bc1d0af78258f067c12bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67503bc3944dba0b136c66dc57e25d0d774f987fc970df873e4bb6490e28c379"
    sha256 cellar: :any_skip_relocation, sonoma:         "951d92f1809f47ef8f2f5cca5887721f03c7bea385b43f34c5c6440ebdef44d2"
    sha256 cellar: :any_skip_relocation, ventura:        "efab50932cce860c9a1469d9d67f342028915353525cb5c608da17ac2e5abb53"
    sha256 cellar: :any_skip_relocation, monterey:       "c28b6533b65912d630b65744a7f2cac1c1058136b79543e4158c5392ff46efb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110a4aecaa669da3c7cb4a2898eaf80b8fdba030a8bf73e1f06f5c2898db5833"
  end

  depends_on "rust" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"aftman.toml").write <<~EOS
      [tools]
      rojo = "rojo-rbx/rojo@7.2.1"
    EOS

    system bin/"aftman", "install", "--no-trust-check"

    assert_predicate testpath/".aftman", :exist?
  end
end
