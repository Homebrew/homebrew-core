class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.38.1.tar.gz"
  sha256 "5fe067b3a77f448f168a3b02f0490ff3bc52215cd09af9d15df7d34bfac622aa"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2ff1004a3fb3cf71d833fdaff0ef0e98286ead3e09ce683bd862b08aec6baeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "483cb93cf8b10e2f7e248f4a2fa4865d2ba25b4fadecb9018bfab79ac413a861"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2836576878035dc94577415e9d1758c93981e06caf32a93e3d4f8b3efdb8e2a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a88cdf3e37e2130b5049404f998fa1637b41701f26c3aac43271b670f204d9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce1d0324b1b97a837a7756e1195fd44e6d15ac9249080fbe2615d9af8b52547"
    sha256 cellar: :any_skip_relocation, monterey:       "0e04ee51565deb0e03a0215b3bfd8cffea7bb9d26e02cc3b9afefa32fcdb1243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad2e30cd16fb49120adf4fc2df04c23942722dddcd477578c74cd0d27116922"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

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
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
