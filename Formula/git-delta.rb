class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.2.0.tar.gz"
  sha256 "c093d40e7a069572fc31407a39dcb6a77094acb5b52518691de6f8f0c21530de"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a684e673f61fdf4e6e5c45b55e5157c8767c524171bc77fa58e6c6a36354ef4c" => :catalina
    sha256 "57c269e6376350be8c706bdd2dcb497c63786ecbef75edcda944d4f7728223f2" => :mojave
    sha256 "9de66aecca7e14b8f74d22d9778559006c1a7d8d1dcb39cbd456060d95d32d20" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
