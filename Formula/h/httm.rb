class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.48.5.tar.gz"
  sha256 "e9b2840619232412b82934ab281801962563423d952fa5cd3887fbb54e77bb6d"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3624f1167e1894404d8102b1f33addee776e0e8bd5993fc85c24629335cd036b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4619b0dc447c8483b9ade36a17a3d483a79e346032e19a4bbec94f10b0e506f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4969be85428365a402ab43507e181c7afda8f9fcc8b546a9829470980586713b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "713b2faf002ea74f90cefe2240cde7d85f0638caaad908718c01669a49b30f2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "20239060c60b898436d758465072d9d9489b702ae17aaaf5c165a990a8fefd65"
    sha256 cellar: :any_skip_relocation, ventura:       "9f8d015f5cab272192cd055e0d93b1dfeb72e751257cf715622803345877feb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7aea874c55234110896b008cc9d7a65cb796f32074ef258f0d6ecf6223d26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "392dbf724b6632884e972680872d115427612f21423c67f787ec79d98f8f6dbe"
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
