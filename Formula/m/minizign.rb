class Minizign < Formula
  desc "Minisign reimplemented in Zig"
  homepage "https://github.com/jedisct1/zig-minisign"
  url "https://github.com/jedisct1/zig-minisign/archive/refs/tags/0.1.12.tar.gz"
  sha256 "4a567fd462e7dc75e3d6f20a300208ca1629a89896119493d53b6d19bec4bca2"
  license "ISC"
  head "https://github.com/jedisct1/zig-minisign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7747a4bf070f657dd5f6df9128074e7f7a5fb12a67bbf72d3a72747a7af22e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901ad4567285ecbfbd9c770bc60261e436f0a9bd3eda9edd4302f98f142f4430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0060297445e8955145eaa9f7eacb2041e16ff8c9f3c58a6b5c803f1861e8b460"
    sha256 cellar: :any_skip_relocation, sonoma:        "83301b5522b4a250708494c16c2e6fe9b045e14a6233ce469b0f9b50a29c7a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238042c6bcf403128dcd157e08a797029b8b57358929779ce9e8f339c3828227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e3b052be65cd52cae297195d1763cef8bf4beee317efefb69fba16fcee9002"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  test do
    # Generate a test key pair with an empty password
    pipe_output("#{bin}/minizign -G -s #{testpath}/test.key -p #{testpath}/test.pub", "\n", 0)
    assert_path_exists testpath/"test.key"
    assert_path_exists testpath/"test.pub"

    # Create a test file and sign it
    (testpath/"test.txt").write "Out of the mountain of despair, a stone of hope."
    system bin/"minizign", "-S", "-s", "test.key", "-m", "test.txt"
    assert_path_exists testpath/"test.txt.minisig"

    # Verify the signature
    system bin/"minizign", "-V", "-p", "test.pub", "-m", "test.txt"
  end
end
