class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "7e86ac3e6eb91c606c55ee0f992c80df889b3c9ec170185a185165e5f4dd1dad"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "375880f68eab51ac9fd293a98660f67e7c3180662efac3f62d3dabf018b29342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "576964332fb50d496ef73e51d75819a42090c04d4b94c0b66ed00b6f4a64bd9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57fca7679dcfc2b4fa5c037b177f0fa3d2f057cd447b1a5ce6de26645daae3d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "19d467e96ecf7ea2f7851b4d35052026c3529fba68e6fc20263389c56ed60470"
    sha256 cellar: :any,                 arm64_linux:   "044954a5228c2a2c4d178505928d5466b8966c40337371023f94c5f485e57761"
    sha256 cellar: :any,                 x86_64_linux:  "849c6a532b90579dc2622c9e5a3524331062061803541ca65f962a1a0457eca5"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://prek.j178.dev for more information", output
  end
end
