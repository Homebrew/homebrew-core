class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.8.tar.gz"
  sha256 "911a8971aeb0e2ebf4ed3df794c4a81dbc89c4cb94f65267c54623a41558a443"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04d97dcbe97242f798d68ff31df1785d435a76bc4c59ecbd89c6b88038b6e5f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ef054a84369b615798ffbdc426c06b7c3369877a10d8275870f23487f3be51a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c178e13a08445bb6edf8bf0cd07a1390ec02e36bc564cffdcd22d3417b8ea4ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "59c33e1002a8e9889efb8561bd4d08efdfded8b5fa64c569e496edd9d9b7a036"
    sha256 cellar: :any_skip_relocation, ventura:        "460d924bcc4ba15ec3263b2e594650415d8899e0e7279d4852e7696691f2d028"
    sha256 cellar: :any_skip_relocation, monterey:       "a9eb2110176cfa7f6c27e374d3e06794d09bfbe31b92f297b76864a365ae1b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1217ebf9485288acb09a250a4fdc2a2d954b285fe9275c9bddb2e62f5953fb6d"
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
