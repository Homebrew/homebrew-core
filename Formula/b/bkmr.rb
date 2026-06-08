class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.4.tar.gz"
  sha256 "4bb7b63bbf17c146a7588bb982c4bf4bbcbd5bde4baf26455d9f69eae4ab5077"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c3fd7fbe2aa85fcf99dbf8007b23e500a8c243789e51303fa9705955102aeec"
    sha256 cellar: :any,                 arm64_sequoia: "54ef269cdf275a85ab95daec4fe757aa428f7cb84f4670dc0a6ca393b808eca0"
    sha256 cellar: :any,                 arm64_sonoma:  "529576b868f1ab4fd04889612001dac34ed821d4f420d6f7b15cdddd9b2263c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3eee9fff458104e3fcfc786d43cdac911920671d633d16376fea3c84a650fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2b0ea5dae4cd453d52ecfea9be51bf7200ff637c3733b3817f2ad0a5b059711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3952c74973c36bf045a43067bc492f5c33bea00b6be74a3868ab8ab45703c988"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
      ENV.append "RUSTFLAGS", "-C link-args=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"

      system "cargo", "install", *std_cargo_args(features: "system-ort"),
             "--no-default-features"
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
