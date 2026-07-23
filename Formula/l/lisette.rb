class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.9.0.tar.gz"
  sha256 "862528a681bdf8079b6d1a48ca4ce053e65cba1751ff319e00fd5861165cf625"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e7a974a5548d0793d0ba6d2f94b048e8e59fd207a02295a2e223816a11afb30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1cb3bc53a32e234adb95cb6823af6bc0bb275d27068b327cfd0a290a1ee716"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20d1086ae9fb67f43700aa252d440f92e156419db97482286b9211aa11b6157c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6023bb29921c006807177889dff167012faf3dc97fc725757afb66ab218216a4"
    sha256 cellar: :any,                 arm64_linux:   "ac38961ff5e41f82583274e608c5db8082e613641e919e57e8f4c720f441981f"
    sha256 cellar: :any,                 x86_64_linux:  "3a9ae46c866522ddf44916203b28974885b5f0f1c82354a4ed8fcb2b2c0efc35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lis version")

    (testpath/"hello.lis").write <<~LIS
      import "go:fmt"

      fn main() {
        fmt.Println("hello")
      }
    LIS
    system bin/"lis", "check", testpath/"hello.lis"
  end
end
