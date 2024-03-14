class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.3.tar.gz"
  sha256 "4ee9e1e910fc627ab61c008a56ab8f265cdfb1f404c8c0313905df3c82ddc141"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9fc8f71198bf4b4904d601afd33ef0669f77410d9bd8b499ea8edb6f8476b1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96c13b48672531dcb2944a82224b59118145a590eee49aa218371bdde9f808d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca4eb35d66153a1ee35bb08bb652ba8216702597d3f89e6173167025075ac08a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e96813197d10ac151caff75ccef680046d7412a6da971d8322ff66a03d42292"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b1bb810a4d6d1b4ce77810eac6251b92ca65210d3cf83ca9e9913bdd89db37"
    sha256 cellar: :any_skip_relocation, monterey:       "00c3fea8a2f4f1190699432514fc2b0f6b57371189bece18aaef3a738c84e7fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55bfe082efb194ea9ead25e240acc71aeea94ff7aba9f7e67a61d5db47babef8"
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
