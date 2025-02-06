class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.45.7.tar.gz"
  sha256 "7c8aaf28c68946b222ff7e5c98ae0bd023c9e676863e493f8dc2e862e599d828"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f50af354ba0f1adf9cfd26064556dda941127d4e274af701ddcd9a12393f2ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe910c445f531a1208983cf33e0ce5f5e2f96f466ff826682f441a4aa792ee75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbada720842421771c19622a841169052f6c374908a12adb10c2f0549bc008b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "553db68666727178d8a86ec33a568c17f1f6f7b6678a24b0800d53cc121b1bcc"
    sha256 cellar: :any_skip_relocation, ventura:       "55e8e5752411164f6f861d1f823437ebc20ff882bb385b2145317905fa56e22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a74a94b52cc9a0663cab58f1ee3170e9e1d5154283178dd7b02327c3310a09e6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
