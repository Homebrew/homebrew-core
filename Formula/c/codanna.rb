class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "1fddc51c500d9905b25c12df5813a29a0e59d7a132afa927c45be81bcc8bb391"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3180cde78e358157f692810525f591d6c1d9b385bbfea80bd7d4cab5c9a4c24b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b52077cb9097aef7aa0008d8ccce29080503406a1d7e2ba0feb4093383b6471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31840de86055d506589929979709798eb7d6303fb089aa8c8d83e718b7f9396e"
    sha256 cellar: :any_skip_relocation, sonoma:        "84033534c825e26c4fbdb458c17a4a04cf863bec194f3084188b9dbfa031be34"
    sha256 cellar: :any,                 arm64_linux:   "d54ebc11853c0e416d53c879494683bbfb2380cb86515ff09cf0df16483be3e6"
    sha256 cellar: :any,                 x86_64_linux:  "891d904616fd664310c756c0e3a13e0a0a2322c03870e45f76df3abdf369ae8c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
