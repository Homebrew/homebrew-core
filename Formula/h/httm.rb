class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.38.2.tar.gz"
  sha256 "bd52926e8d39a735a2694412a578168a08a4f0c7c2cc66e8afaf750481005ae2"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b1c0c7ed7e19b3692bfcb0b94fb14eea00faa29279a832c59a7e96958e8aa1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b82efeba25a47067811918d4394ef7a2bf937895d80bf4f47e998a91a31abe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01cf3b8f4d4b15a647ba1e77b4faa35d7733ff5707739baee0337bfdf8f5c8cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "35c9f02794ecdb1cfc40e39f6067e547ec43806c4e931ebb062ea1a46a5d82f4"
    sha256 cellar: :any_skip_relocation, ventura:        "b8073dd29bdd416881feed76aa01cd5882ae0ce811315c941b3317c891c9a719"
    sha256 cellar: :any_skip_relocation, monterey:       "a1bd675d25f9776f5ea623424e956c612947a1ae034f38906b98cd0bba3b0dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c72394b14e42e1882aab82ddd60ae5847584f2992bf3646f3f4b5102a3a50e57"
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
