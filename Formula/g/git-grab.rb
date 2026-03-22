class GitGrab < Formula
  desc "Clone a git repository into a standard location organised by domain and path"
  homepage "https://github.com/wezm/git-grab"
  url "https://github.com/wezm/git-grab/archive/refs/tags/4.0.1.tar.gz"
  sha256 "63c080d78dd1d5213b59ae0b98418b9f374c59ccfaa444c55e99b7004fd4fe13"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "075c51d96c664c13d360040e6603257e37181c629a195d990258d25e06fd9540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020529f0d1e5b083b40119ecc60f67749740fc419c4c042cf4744c004c3fbb33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35acf35a413f16f22a9c3df4925f4e8c8e1a816b431aa20ea2f39c5c60e768b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e6eab11a1005cf3bc5caec03844638fa863fdea647b7ee374bbf1b8c4ed727d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d8a40549cc942135ea8db73a4154263078b1b803fe269e436dad35756463bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46bceb04f6dcdfb898f6af02f4c285e29a2ed50f7694ca5dc8aef88d64d2592d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "grab", "--home", testpath, "https://github.com/wezm/git-grab.git"
    assert_path_exists testpath/"github.com/wezm/git-grab/Cargo.toml"

    assert_match "git-grab version #{version}", shell_output("#{bin}/git-grab --version")
  end
end
