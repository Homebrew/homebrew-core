class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.10.1.tar.gz"
  sha256 "4d84e172136909c9e7c33399ec8c79e506142213232edda391e6c2e288579922"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "592734771fdcce6010bdc1f2b6793dbfdc4594db8107d4b4bd158dd4fa6ac27c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d26d89507aff6c5bfd9948fbb3982176c6ea5d2d028c8afacc71bc5b2765c9d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5f2fb418e88bff5fa1b0073737cba875dcc8ba87e331db728ee390b201fa96d"
    sha256 cellar: :any,                 arm64_linux:       "2ed51b1d82d4e92364dc747e0919bffceb6a91c85482527620ad42b11774ec0a"
    sha256 cellar: :any,                 x86_64_linux:      "ec1fbfc1b389b84addbf7ee062b5bc9dc7ae686f5027d4b2076c87d1d86b2c77"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"

  uses_from_macos "python"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "bkmr/Cargo.toml"
  end

  def install
    # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: formula_opt_lib("onnxruntime"))}"

    cd "bkmr" do
      system "cargo", "install", "--no-default-features", *std_cargo_args(features: "system-ort")
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
